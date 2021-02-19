Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56DCB31F3B0
	for <lists+kvm@lfdr.de>; Fri, 19 Feb 2021 02:51:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbhBSBvW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Feb 2021 20:51:22 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:51976 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbhBSBvV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Feb 2021 20:51:21 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11J1k10V081831;
        Fri, 19 Feb 2021 01:50:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : in-reply-to : references : date : message-id : content-type :
 mime-version; s=corp-2020-01-29;
 bh=+QG1zWH1ppShT0dMhv1m48pdvl6SN4oIUNnr+QC+e3o=;
 b=QjdjURj8CXTgoe80LWlXapmXVFp/RYotJ6BaERi8K45tOxs9A14/cKp5Hp+8vkuRRqxo
 f6sCdWxvyVk7XYP5w8eJaB3QUBxzlwdCpyWFdq3R8her0s1c7uQCBdpGX5Hmk25nFRKk
 PghDtqVrc297wNWurShMgAbmzpLaOhECk++vkZX/qg5xmUMbjPf45pcTrmK5G5iudcuL
 lhpdsKvK53Da6KCWJtUNxwGSAgT/JVJp2otplPK3DvZZ30RrCLpuPPZWr2jBePMLHnSl
 ivFZ8JZcJi0VFEgQIWxA3SEFS4OsTTRMIeHC0ubT+DWIEMQJDc1YYNzEHinSZQQZ3RXi Ow== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 36p66r7xge-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Feb 2021 01:50:25 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11J1kQJj073127;
        Fri, 19 Feb 2021 01:50:25 GMT
Received: from nam04-sn1-obe.outbound.protection.outlook.com (mail-sn1nam04lp2058.outbound.protection.outlook.com [104.47.44.58])
        by userp3030.oracle.com with ESMTP id 36prq19d4h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Feb 2021 01:50:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fxa7PQF/NW5WEgwbBYf7xYEz0a0dLflKEieCZyZ+C1EFxiqEuk8p3no0IsrWYXXevrDTDYOxm7cALFVM+OK88U2W4AxCyZXQYNJk4q47ZETSk/om5/m87hukVg7VCxYDkp1eROHsuExVp713iJfwpPa1lCoW/50+PESQkEnSy55BvGoPTiqeaRvP8D06FkafcCXgSOV1InhraNOMF+/sykh2ftQEUCkkwGIbENABPbcuuzt1HgtzI2dJk/T2u9KI0e1xOhPaKmMobxuXbBouGk7gU0fIEPt4vBXTZWwzczY1zT0MyL+gbwDBI2uaEqhQhP5JldBqmJQ/epjkXWzn6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+QG1zWH1ppShT0dMhv1m48pdvl6SN4oIUNnr+QC+e3o=;
 b=hA6K2nMa2x+p1mLcu57HIo7NxZw9tLgwCMOZPZr8TEBGoCrPPQ9VJhhX+XfaiS+5OIV3bPr6Nvb09HNGuVlY5KEQXKigKV+qTkE2hEL8ZqDT6WjCqayUfBwlAQlVxm/RowPDDQMkgaIENZvUa8lWvkQGDpRfs+NThmKkbR6EHUc0dS/Qa2E28kwup7q+IYtcyr4vWmJBDy2h+RpeYSFO85v6Zfx9LhNyhsIYkxWsy+ifvsJf7TmTFKljsg6gMadZH40Lv/necJvVa932Ccaug9G33BRQsoTm6T1W0S3VpwRT1DqxzBChwCm5BwenY9/XF326zltq/Bp7MfPGj2pnRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+QG1zWH1ppShT0dMhv1m48pdvl6SN4oIUNnr+QC+e3o=;
 b=STdlAKENemt8rqfQaNu9I6zfCMvUQWEMm1jBse/WGCdrmzzjHzn+hphZeqcdNQT3nIuhLC3WCKcaVmmN4bniYZprZRRflRU6arBa39f7px5VRFdt4nKJLDV+Ughq21b5pjSDpIgd2cQr6396aD5RSqixc7dLAKb6HNFB+Nf7fL4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR10MB1774.namprd10.prod.outlook.com (2603:10b6:301:9::13)
 by CO1PR10MB4468.namprd10.prod.outlook.com (2603:10b6:303:6c::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.26; Fri, 19 Feb
 2021 01:50:23 +0000
Received: from MWHPR10MB1774.namprd10.prod.outlook.com
 ([fe80::24eb:1300:dd70:4183]) by MWHPR10MB1774.namprd10.prod.outlook.com
 ([fe80::24eb:1300:dd70:4183%3]) with mapi id 15.20.3846.042; Fri, 19 Feb 2021
 01:50:23 +0000
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Matthew Wilcox <willy@infradead.org>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Steven Sistare <steven.sistare@oracle.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] vfio/type1: batch page pinning
In-Reply-To: <20210218120153.4023ae85@omen.home.shazbot.org>
References: <20210203204756.125734-1-daniel.m.jordan@oracle.com>
 <20210203204756.125734-4-daniel.m.jordan@oracle.com>
 <20210218120153.4023ae85@omen.home.shazbot.org>
Date:   Thu, 18 Feb 2021 20:50:08 -0500
Message-ID: <87mtw0x1v3.fsf@oracle.com>
Content-Type: text/plain
X-Originating-IP: [98.229.125.203]
X-ClientProxiedBy: MN2PR03CA0002.namprd03.prod.outlook.com
 (2603:10b6:208:23a::7) To MWHPR10MB1774.namprd10.prod.outlook.com
 (2603:10b6:301:9::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from parnassus (98.229.125.203) by MN2PR03CA0002.namprd03.prod.outlook.com (2603:10b6:208:23a::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Fri, 19 Feb 2021 01:50:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d2e43920-fdfe-4d46-ead6-08d8d478b8a7
X-MS-TrafficTypeDiagnostic: CO1PR10MB4468:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO1PR10MB44686FC1352B946AE6942E7FD9849@CO1PR10MB4468.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d7ktVdIjOztRHh8iqLG/XT53iZKHOmS2eDbQhe464ulQ+Qp0PyGXAJgZw0WbqkC1CXns7KGUqvsq/+ZM8vhEKaHpJONKQCyIkXm6PZbrU6BZgngWuGC4HHMthW9g/qeoqj1UeHS0q/xAdN3Dp/UtNijNCwvSq/8p19VzzAO3u67Z/gi60Ww8tGdAPJecLAFnGK5xl8ZU7gaqB3iyW59UskpICVjRNQe+p5E+pZ3fLvMSetrVL41d5c2GhUttoiPEZN4UsMvSb5K6f1YShhEz7y01xlQ9bjG2oUgelVNOx5k3KIP6w0fnFRNL4sXJVfMF3b+g/BSC6QFlAcknNPAMB3dTbihjX0UGmVmdQ6k9gLb3NWAuPw0VTyQHWreL5/RJ51Z87JuhJRPFswLmQGNDlEnJhpYOz4atsbmiYQdsMLPoR/OzNmtF71yTRUU1VO+Xhntn0eNY1UF/l0CLSY0KReafX1Q3Zrsd80N0DVgMf0D6fpNfonOG4xCLA8KlW52HeFlyLRbXDRVyk6IbbZk0NA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR10MB1774.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(376002)(39860400002)(396003)(346002)(66476007)(2616005)(66946007)(6486002)(6666004)(558084003)(6496006)(36756003)(26005)(5660300002)(4326008)(186003)(6916009)(956004)(54906003)(2906002)(8936002)(316002)(16526019)(86362001)(66556008)(8676002)(52116002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?tSmIU6as9tenNCqfytWTJhk8EpO4E9gme2YmHJPkiWjUXSO9QMoWa1ee1Ysz?=
 =?us-ascii?Q?MqfEaPKI1cLwONtK65nef09JrVT1tGWgDSBcgcVibOyx+EwqplhECw5xu7MM?=
 =?us-ascii?Q?acnGUU3Da8zrbUtYiDSv867FfqBd7y785swMjKILNVyK8T4rsysYQYpXwsLE?=
 =?us-ascii?Q?zjd2HyBK6yWdiDTaStPRQeopHXX23LFBeIeY5m7ycph78MKMXxS4Igmoqguv?=
 =?us-ascii?Q?AwcBn6eb9gmH2+SWA0B1kDshbU3kgSpLCMu62+DE7QMC8IRl1sPzueyZY/qq?=
 =?us-ascii?Q?fL0hHzdnf3HwE75K6oaRg/uzm32K6O5WUDq48zB56mXMmg+P68j6JXxpZ5kj?=
 =?us-ascii?Q?vAUrAs3OQMgbT3NiDT9Y2FXMe4ZaXxjt/8IAMVIT7jPNzTUhONQS1Z8a9ujt?=
 =?us-ascii?Q?W3fSSkQLKIycb2ygjQ6dpBYc9yX0YkrjN3zjMrNeZOyjKzdJCkHQeAEFj9Zs?=
 =?us-ascii?Q?nJv3WZueNg1TiA0McoNAkeXB82mDPy8d4FyJY9v6+hrLG7lkPsKOWPyH6Ybw?=
 =?us-ascii?Q?e3CjgR6k7Wr9hOkp57fmJktH91kOGXX1pZOJwy9jKTOKC0HORxeH08Z+Ieee?=
 =?us-ascii?Q?4aMlIsz3CIaZvtnyt5zg390PcJODXXsl0qWjso6OnZtqOSOwz6/LIccx1n89?=
 =?us-ascii?Q?J6APamCng6wlfCmiythhKXdFosF7If0dAmaRRgbCdsJpgJHbF9qktFmGa2ZO?=
 =?us-ascii?Q?EOhBJwoT1efzrzqdDutCA0m87CIAQg8dIY+xrMIN1JU8LI6+Ng6ntdZ0ICTc?=
 =?us-ascii?Q?iMen9qT0KAZXYDFQ9jArtuTiQpgc1x3MujGQd8SSmFCrLcfPmeCz/jSPoh71?=
 =?us-ascii?Q?i+9Nlf+jN2r9b8XFCqVDNuLqJp0Oq6UV8LXSlSzxfqA63Vy4Gpr3s2ruQI4p?=
 =?us-ascii?Q?Z2i5c+lsWA9X0EOF5Z2Cw7oZ6lLmObh9ESphPY9xrg+QMYkWqHqDBpQyxm7Q?=
 =?us-ascii?Q?xlywZ9Hapjpot+DYsAwX1aJ33bOup1H12JdegY6RLQ54g6Fr3hCsVgEvtiRY?=
 =?us-ascii?Q?3jdLZj6HdiAt6Hh2EvfeK64fcroWhPh23E44vav0fhHjDqiZDd4KKyP+S7Ub?=
 =?us-ascii?Q?y8pr6Y0xEQwmtofOq3CQMFwVSoxMdzbQJGu1azHMiEaAukHExyVlCFQdsLcS?=
 =?us-ascii?Q?r0JLLm1WxiXn3gLY84NH1uB1vnkOVS4nqYbM5PnoXDX/qeXDgM34N0JMjXZv?=
 =?us-ascii?Q?J13+GzL4b73HxCORzjhel3Ge4wIRvDrDfzRXmkUk4HDUEEbdmZj1wTIvPPnv?=
 =?us-ascii?Q?bMJ5IumilF9vFghHMyQVS724Xw90SPzmvR+fyEBAJVWbh82KArDW/ZPMwgb/?=
 =?us-ascii?Q?k6o7iqO/WqmTOQbyvD1rzcF3?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2e43920-fdfe-4d46-ead6-08d8d478b8a7
X-MS-Exchange-CrossTenant-AuthSource: MWHPR10MB1774.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2021 01:50:23.5090
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MukJ1h3dJvjUJpw5sa7JVETxEFRm3Kqqe1mR4yL8tJtSwSsoBAE8Mz9PdSYwcjkaphOHG9Dy58U6o7gXI5G/DJWhvPsMwDjHD+TlEoUavbI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4468
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9899 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 phishscore=0 adultscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102190008
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9899 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 suspectscore=0
 impostorscore=0 priorityscore=1501 clxscore=1015 spamscore=0 mlxscore=0
 phishscore=0 malwarescore=0 bulkscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102190008
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Alex Williamson <alex.williamson@redhat.com> writes:
> This might not be the first batch we fill, I think this needs to unwind
> rather than direct return.

So it does, well spotted.  And it's the same thing with the ENODEV case
farther up.

> Series looks good otherwise.

Thanks for going through it!
