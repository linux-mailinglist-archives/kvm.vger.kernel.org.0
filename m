Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 858602A9EB7
	for <lists+kvm@lfdr.de>; Fri,  6 Nov 2020 21:53:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728498AbgKFUxG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Nov 2020 15:53:06 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:21232 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728408AbgKFUxF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 6 Nov 2020 15:53:05 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 0A6KjrBR012851;
        Fri, 6 Nov 2020 12:52:55 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=dADz7lCdb/Fh/48wziLvmcrqqsrD/qeLdHgRLbf0GSs=;
 b=iVNhStLkMe6GoyvB087QZNY0wOJ9JG7mBO5GxJ3aoRms3UCyClGZrSs4z4onNIdHZNVw
 irYWkRBIoZV9OsuY2MOaF+laPuOdIZ5ZLW0qagIm/GAjDopkBLuLEkgroFV3SbzTLn9v
 bZkWZ5mvk0Z1fn1xQCR6UyTzFbLO10pOITo= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 34m5r1bvn9-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 06 Nov 2020 12:52:54 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 6 Nov 2020 12:52:51 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HqmLt7ZLph6hBY35u4fkhnI8/inJ7Y+mRFzsaF17T7NMeU1SKJvYRhWEQI7kJ46BKQ9NsOTFnxbNIDhSqNowCmYZdft6ZbgROBVmA4x/cUXgU8M+8TqRm6t5Or4mC03Flc6McSPFvsO5DxS8yI3euRwUN6f0eNVO3HpGSm5ItDT/EYePzblqXX233661speu0Yf6gKd43eEW6vM3Z+djnrLrwU3Q/BUdrOpodqBH0KkVzyhSx3VMCpf5wPq3Sb8OIoEEpBM5f2nVdGJgikK0EZ5FV1lpPe/K5DPq3ik2vMp42jI7eTJwCxZdkBFNrm3G2F0zLuq1jW4l8P/rgm3nLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dADz7lCdb/Fh/48wziLvmcrqqsrD/qeLdHgRLbf0GSs=;
 b=JnGNEkNZr9yaCMYGisY1hOpLVrKIosg5xjmnZQe2xyrj6y6BfQrSSRHdWFX+WkbVvzGYk+ACtekUekaqBRtpnE7h5XHS5LT+vsc+3VouheU/MXA3dm+5IcYJICSHpLnRJCKR+eCISNPSDPQombZQWHL4WCHaJnWCRBCDOO/fkNPaLpZ92ifqOyk/EKaE1YTO2A5AjuwvCjkvliw7l5Iw7ginMtrfeMvvIxwHdt2Tjl8r2kjBBlfZ09wgzDMinZidNwVbuGojAkv0vwxBGmbb0CFEAersHPcMVS+AIgtiKeMIEYtIxr5OHSCofOxFPEZ7Xuzh3sx3K2aYXBO+oZniwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dADz7lCdb/Fh/48wziLvmcrqqsrD/qeLdHgRLbf0GSs=;
 b=QNqIiIS8c9xV5C3zEBmS2h6Z7l5lm4YqkRJXcZJ+6ogk84gZNDt40O1h5bKBRcibPbrJKgoD/OuoSmREJvkcti7Jg04fhkrYmSfQIMNFhnWsFxDLBxluufgb6N72u+nvK75Lq9tieciWHZSY/P97GE1ofCLQFfZoUOG2wgpptw0=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4136.namprd15.prod.outlook.com (2603:10b6:a03:96::24)
 by BYAPR15MB3400.namprd15.prod.outlook.com (2603:10b6:a03:10f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.27; Fri, 6 Nov
 2020 20:52:50 +0000
Received: from BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::d834:4987:4916:70f2]) by BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::d834:4987:4916:70f2%5]) with mapi id 15.20.3499.032; Fri, 6 Nov 2020
 20:52:50 +0000
Date:   Fri, 6 Nov 2020 12:52:45 -0800
From:   Roman Gushchin <guro@fb.com>
To:     Shakeel Butt <shakeelb@google.com>
CC:     Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: Re: [PATCH] mm, kvm: account kvm_vcpu_mmap to kmemcg
Message-ID: <20201106205245.GB2285866@carbon.dhcp.thefacebook.com>
References: <20201106202923.2087414-1-shakeelb@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201106202923.2087414-1-shakeelb@google.com>
X-Originating-IP: [2620:10d:c090:400::5:d51d]
X-ClientProxiedBy: MWHPR13CA0005.namprd13.prod.outlook.com
 (2603:10b6:300:16::15) To BYAPR15MB4136.namprd15.prod.outlook.com
 (2603:10b6:a03:96::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from carbon.dhcp.thefacebook.com (2620:10d:c090:400::5:d51d) by MWHPR13CA0005.namprd13.prod.outlook.com (2603:10b6:300:16::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.10 via Frontend Transport; Fri, 6 Nov 2020 20:52:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 307e8e80-0683-4720-4a39-08d88295ecc7
X-MS-TrafficTypeDiagnostic: BYAPR15MB3400:
X-Microsoft-Antispam-PRVS: <BYAPR15MB3400164EF98E79DB5A5A3D1EBEED0@BYAPR15MB3400.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: K7+PqgyrWj5VA9UF6ELUOOXRetAlY5Di9uTsXufnrlT29dBhIb+PgRmJRMoQJrtF4ILwFxlDE1qIxyG62XmvW6VHU9OkoF1Jg/07tFjmeGh+huFFMDp1/GNu5gkiXr8l/va/TD4m5BU7iE4w17f8ARBcqAeLYzMI55YaMvFFuzygNhHiS3MNsCsNPeOPjDbzxuJI/fS8we0MT8rdzq/qTCSH4w4VMK03aThSOsJvrQZFkLC49rKDZ9Y1iM8lrhPJ7h/rbYv5oW9fO4wIropIjU/2XRhBNq2Rz938xF5Crp+SFgDl+2HdtAAGtD9m8rlrWpLf24KkzHjx0g2Z65lH4g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4136.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(39860400002)(376002)(346002)(366004)(66476007)(6506007)(186003)(2906002)(8676002)(6916009)(16526019)(54906003)(6666004)(66946007)(86362001)(4744005)(52116002)(8936002)(4326008)(478600001)(9686003)(5660300002)(83380400001)(55016002)(316002)(1076003)(33656002)(66556008)(7696005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: jYW+sAUJ3ylD7pOHSjiEzMAJfzqZWYBkcIoqrmeoXr72DMPwlTQeSikOZhYOzim4xCqYLme5Al855LIhBU8cPaG8zWvrA3PejOLLbdrS8hmePliLPLMJKJUTpla8Bwp0eP1fTyEcQnvybggaKAZX8TauYOb+yp5prlOdZ1TNtgyT497eBx1zUSMCzK1/4r53fUkZ0nqIpFhaSiLiVRbYtNTr3ysG/MhPH5gJnDSBQ70fdhZP8RwYsChIwbat5mrWQx/ab4GhohMSi7rJ3yFWMo66PokqNVHjQU0aibD3sw4v6HZntNEYx79d1szTlua0ZM5VJDOaMAw6JTvO02f462wNZfS9Aa+2pjx65/p41gR00CFm4M113oCJluxdqiSauoiap+glXJs4xNkx5Irtg6R7JDCLKIfHm3xfwNXABKpPmSLt76s6ltOlebe3iiogTUwpFeTfb/R9yadTOcyoVyDRcsnpczZEGuZkHti1l7GMw10+QLI9OZGgBhXw5KTubgU4LZHpukZcg5RNeEuoZZ2ueRTpRY8/ZU0/uhyF6cFZoKxBgPJl9vxbCeziBsvPOpj1rxwUncCPcgq7PVdSQzTN5rXFr40MPhJ5JhT26vC7fVPAWfL+sJrwUaVJQjH81wBT5Q9x9MtEiurUtC/v2sewEeMeIPQxcFDzUpgDT8Y=
X-MS-Exchange-CrossTenant-Network-Message-Id: 307e8e80-0683-4720-4a39-08d88295ecc7
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4136.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2020 20:52:50.8216
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5FT5tHAmO5HkecplEu07hK81vcF69CuWzUk1UAE0ef//mvLons+i1qCjd7Gv8kEA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3400
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-06_06:2020-11-05,2020-11-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0 adultscore=0
 priorityscore=1501 lowpriorityscore=0 mlxlogscore=798 bulkscore=0
 malwarescore=0 phishscore=0 mlxscore=0 clxscore=1011 impostorscore=0
 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011060146
X-FB-Internal: deliver
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 06, 2020 at 12:29:23PM -0800, Shakeel Butt wrote:
> A VCPU of a VM can allocate couple of pages which can be mmap'ed by the
> user space application. At the moment this memory is not charged to the
> memcg of the VMM. On a large machine running large number of VMs or
> small number of VMs having large number of VCPUs, this unaccounted
> memory can be very significant. So, charge this memory to the memcg of
> the VMM. Please note that lifetime of these allocations corresponds to
> the lifetime of the VMM.
> 
> Signed-off-by: Shakeel Butt <shakeelb@google.com>
> ---

Acked-by: Roman Gushchin <guro@fb.com>

Thanks, Shakeel!
