Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 331A33BE8F1
	for <lists+kvm@lfdr.de>; Wed,  7 Jul 2021 15:43:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231700AbhGGNqa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jul 2021 09:46:30 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:53456 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231357AbhGGNq3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 7 Jul 2021 09:46:29 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 167DWGP1031042;
        Wed, 7 Jul 2021 13:43:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2020-01-29;
 bh=5w6L0OvmMdVPQvN/XG4GxVwPe4yVKENpr3Tf8xv07ck=;
 b=RdjdZAsDyZqvH1E5EaL8LOj5dl4CV6/Mhg1jC/gbUShUZlG1FxTVXhLnJkVSiVXXumZ0
 Mmhik72yY38Cx0Mi8mUDFvkNMwawYJO6oSUxoAxZF90iPbl37lkwU+VvoAhuF2AH6Zic
 hAxkWBSJKW/T+OrTMVZwKp1MWujmyHevaLGeHctqfhit+GBl7q73yhfAtsiNygvL5JzV
 NujvabNqT8rtKtHqMWIG7Xr7LgRbGBUqdumQeAYucBugVzzpcxCC9mkSYmY7gAjo2bwT
 xYz4pbH13ZM0RgR2ylaL0KoFVn/8z2dICen16ReRYzHntP0omAPttwbHKEeVCxhV87FP yA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 39n4yd0xfx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Jul 2021 13:43:18 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 167Dah2J042818;
        Wed, 7 Jul 2021 13:43:17 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2176.outbound.protection.outlook.com [104.47.58.176])
        by aserp3030.oracle.com with ESMTP id 39nbg25wnn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Jul 2021 13:43:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gFXr0dXCSL8TMbtL44mZNW74GQTtF1bhitIEPVrpnDHMRkKcBfsw6iMl42esv2vNyef2aDkv37qC43y505y3q3FiYAaNE9riZmmDectW1eWPg4ATWObclAFVCXfkERoSaspB3DM8VxICjh1RMxodJ8M1DZlDxj1NS7in27k+6bErzm41zCbV+ZgjTAokv3VFs8YseSF0sDlo3sFwSro2bwgswx6baniFX6YTJ3aUmJDqwaypRIH1c74J9VA6OLEvVtdr9B5mTp/hMCk8IDwcZTgTiyu9adBLnXJs2X/x/DL0ptdfnLDTSLSk5jcyy7ThwQWxjgZyvg6w8QRLhxpljA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5w6L0OvmMdVPQvN/XG4GxVwPe4yVKENpr3Tf8xv07ck=;
 b=TP6oQF1y/hNSx1npwMth08Q2Qe7CtPP78KvaW2pn2MwZ0ORdxDEaokrMskcEGglmqWio2e5JcpwPJPE6QvbpyXYJvUs51i/XwR6rIVvbV7phaFk6pJdt2SLXd+jQqOaEfDusD5EwLqRgK5FdKEHrz1UzCzJmxlw1IvVtyzMxKK0APvLKXSE8vP2dFYiLLuqGKLvLjP5HYQOReFfMQFypcZ9tl88WWjMr8/gTAUA9VKIdXZ3MHO1WhZ8SP6qC6dPIJ2OkKKLkwL7GkLuuEr/u6/WCuAIgTMWbydn7+F3dKRYbt5d53Q1/GBAApezOwSLwK9K70gwsAt3HMil+6J4SAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5w6L0OvmMdVPQvN/XG4GxVwPe4yVKENpr3Tf8xv07ck=;
 b=bixx8QWm7oaVsHQPbaRf6iCIseM2bOeRtjA+jkqdxt0ebfKGBZn8tWF3P3hUmpj7LnoIs1zNVPXeB5sQFEjC/7H6BdB4rA4PjBgKrRkcYJ/idDzx0ouNe5yN7IlAw2T6DRI+5sSGjUjP5WgmRc6rYd5l4BDzWAdIaH9vHJh+5Qo=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1422.namprd10.prod.outlook.com
 (2603:10b6:300:22::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.26; Wed, 7 Jul
 2021 13:43:15 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::3413:3c61:5067:ba73]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::3413:3c61:5067:ba73%5]) with mapi id 15.20.4287.033; Wed, 7 Jul 2021
 13:43:15 +0000
Date:   Wed, 7 Jul 2021 16:42:55 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Steve Rutherford <srutherford@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Ashish Kalra <ashish.kalra@amd.com>
Subject: Re: [PATCH 0/2] KVM: SVM: Fix error handling bugs in SEV migration
Message-ID: <20210707134255.GX26672@kadam>
References: <20210506175826.2166383-1-seanjc@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210506175826.2166383-1-seanjc@google.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JN2P275CA0046.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:2::34)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kadam (102.222.70.252) by JN2P275CA0046.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:2::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend Transport; Wed, 7 Jul 2021 13:43:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4cf27f7d-9ae3-4405-1db6-08d9414d2b98
X-MS-TrafficTypeDiagnostic: MWHPR10MB1422:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB14228039496F52CE7EA5F2A28E1A9@MWHPR10MB1422.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1728;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xELfaUWPJ18UpbH+H8p1bbnyVaOJixhVKnC+p5l4KraXnNMOSnTy83TLg6J6Mgf8ifBcZL/6gNElMJH7qyoBxw+QCEYbyUCoQbe+/DZDdVriTJwWzG/5vNl+6Ea6wtj0LFM5aGUjHFE7pfa/x+vr3dhmWsYgok+VEA+fmQcTiXxdDDk8EY/N0Ze1squkI/OCDGNXyIuSMDjyzRsY/ZJn01qM35BIrpuju1kUpRF37yafQvrwQSuCp3kT6NYBjZfV1Bl8iTpdUjRmoO+UoV3VgOpDxBG1xXVN6+YZgexIObfZb+G6xmTV3VfSwgl3htHYknYN2LYLYU2QH52PRppdxD/lI8F7gazahDxMKDtF1Ia2Z88C63l3npcDXNocpyMzBLu8qOVtXE6nzmAD75EtIsW75cTik5LCZYMFJTTS23GkyCq96I0AT3X+eMmkOoGs2jT1SrcAo+rFGqumY885FHw/vGUMZCKb5A6WCgvo254WfiDGoKuGsihpeDpKBOKVawE33E494tVsPOAMerrdSniISgLHWKnX+SzWOZwZp7soJswJY9ER50ptYiBhPW/WfgPF0n+fyIz0Ry/4b2Hos+xta7JswAeK4bgSRjLkqyOuH8ZTyh7bzdc35kr/QSalX7o9yxbPgNzLiOTxBHH2A7WfHIaBflU7Zbe2/2Me0f6qbEHB6p0XH2Dk8FdRDKeVONbn+FHfmbSbJDshZOCnGw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(376002)(136003)(346002)(366004)(66556008)(956004)(316002)(33716001)(1076003)(8676002)(38100700002)(6916009)(52116002)(5660300002)(9576002)(38350700002)(86362001)(55016002)(558084003)(54906003)(66946007)(9686003)(66476007)(8936002)(186003)(2906002)(7416002)(6666004)(4326008)(33656002)(4270600006)(6496006)(26005)(19618925003)(478600001)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YwuUB2Mb40ixfPwQMRodQPObV1eCN97ae55K3BV59asKZNV/LPDJHpSHeYZP?=
 =?us-ascii?Q?g79wNhOZLJMPkZqwaoxxE42tLuu37AfmujJpusbDkLTVHQbfk9QtXyqlky+D?=
 =?us-ascii?Q?cgMOBDKO/5COFich3ybZNhtupRe498Y4bwtJd/4K4YkyNV13NVmIn87ZaJXE?=
 =?us-ascii?Q?0Fh+2kHrZHC6N+OvIOhDVCSTAk6/570CQ9fAazknsNgOjNbu+gT45imFHWK1?=
 =?us-ascii?Q?fMUpK6R9cbSc7iTPMKzIR/7O2SvI/2bjMUOXfNXGlbWEmazA4PsyUFTM5gIC?=
 =?us-ascii?Q?LMTjw1mvtcZMAhO8q21UPzpSyi5GqbcSRPuPD9TocxEWoxDIOKNomujpU6zM?=
 =?us-ascii?Q?zMRkA6EA1gN/HW1K5uYhPWVWDeJgcJCwVeK1/obShqOzPbH8LlKcD8EwPOsk?=
 =?us-ascii?Q?G+Vshk9YjZyhZi1gang3Al9nTQR2DCFjqQYJN0iqZLXXwi5MvC3n+w9Ysbvj?=
 =?us-ascii?Q?OZ09lislgoVeSk0jzAl7lxjK3FyzHVUO/WxprEgCylvDFleePLHodpZt97iQ?=
 =?us-ascii?Q?eaIJMlHvg9ng0ciqlboQoFB1Kyn8rgcbVQGV/tQPrq0wp9+xajG1EjTCLp9B?=
 =?us-ascii?Q?Q7fFX3rvFjl7pKVWBGn6s5o2NmJO33V+W13AP0LbVbYmn5dvfdKNcSu8iGyx?=
 =?us-ascii?Q?5nugxfARqCaZkenCSG5XvD8iQd6s7N1BXT+JSTpBAohfb+YojCS56V7XcyzD?=
 =?us-ascii?Q?puasftOOYSrbKcz+rwnCgoCe10fX8yF/1TvTlrPaeL5aQxmhaExrN/HLWi1S?=
 =?us-ascii?Q?ATKPlX5rncrXEcRKD3LVocEvEG3t2VZKjhq4Byums1DyB6NuXWGNLYksPAb+?=
 =?us-ascii?Q?aEsChXoioyt10IRmAU+NEA1rudyds/LX2Iqp2DhTVcQEsnaM0AUz/ix6OmKe?=
 =?us-ascii?Q?MxZ2k0rzbMC2isy+OyYri+0lS7ANLnLDYdiASp2SM+ZmJsBbSKGXee7dCm0h?=
 =?us-ascii?Q?kbd2KtSFxQ8vChIQxXdgv6CCn62c4E14VBf9hNqSw7qxUAhgND3+wZSB/2Bn?=
 =?us-ascii?Q?uQJ21AGKxJU2EEQeMh/RXJRQaXD0KJG7aghk4OMHHbloxzWaWtdBSlBbIbsd?=
 =?us-ascii?Q?3Xw0Q71vUM+MTwzA/saY2+rOM3h57Ca/xCOlD5yq4pmP3q/1DxyK0lsQ+Ot+?=
 =?us-ascii?Q?8belG8jwOG/cMA5EtsvjclS/IhG4BHEqb9Vdb8DRS2xKJyr4W+JM/Ks4MT3c?=
 =?us-ascii?Q?syD971CBaY+pKArI00DMsbxaybzzgLFN72tWUy7IJvm8tVjdFsreMjn43wLd?=
 =?us-ascii?Q?PfZk+jXft7TKUpW/CbcTId5Dg9BUkXPkzmMQCqPIbojyVc4eFvmQBe1/BzUJ?=
 =?us-ascii?Q?VR5nL4rkQqTixd3v9W8DlR8N?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cf27f7d-9ae3-4405-1db6-08d9414d2b98
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2021 13:43:15.1691
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5kYBA9/puSktG1iiWCWm+NSdnwzfzJRn8xtZiYYLioXl9ESkSXEP2iyyVzSMlJ7YmtFha650UpCvpyUo2l+kmP5Jh+b78fxI7yn2IJzUnE8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1422
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10037 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 phishscore=0 adultscore=0 suspectscore=0 spamscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107070081
X-Proofpoint-GUID: 1fs6PHc4cVbriqxYyZEa2O2-24HKXId2
X-Proofpoint-ORIG-GUID: 1fs6PHc4cVbriqxYyZEa2O2-24HKXId2
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

These patches were never applied.

regards,
dan carpenter

