Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B089A4B9FBF
	for <lists+kvm@lfdr.de>; Thu, 17 Feb 2022 13:09:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240263AbiBQMIl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Feb 2022 07:08:41 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240256AbiBQMIh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Feb 2022 07:08:37 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E31256378;
        Thu, 17 Feb 2022 04:08:20 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21HBjht2021438;
        Thu, 17 Feb 2022 12:07:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : references : date : in-reply-to : message-id : content-type :
 mime-version; s=corp-2021-07-09;
 bh=nKpPv/o/oIGYZJ/IhGUMA9JZVd1tqItJCW+GQKKHDV0=;
 b=njHQUQrSZXusS7QUiosIjAWKRHZEl5zehsUCc8XGNmm9OJwkF4KauSsXwXUPmco/nA02
 d/exocelk2sKC9rb857nQsmVlSlLG5aNQHaQO1oHvGV7KrN2++cPYEhPo24Mw3ZbRtzU
 LeekSThp+omaoaiOxeLefNUqlixKm5TQJCjyc+tAZOOJzcalZTUhOicNLg6XvW7mSOqK
 8/fwA5ojAvfW/6t+2uXYIGpLKYObkedRCbmvjgV8ACiwfieing20VyVoqHOpwfSzeOnW
 bH+PFANNQxLlS70+OzGh6HwGbEI7MqCSV52PMf81xeJt9XWyubC/n9BH6ahovO/7eWiO KQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e8n3fd6a7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Feb 2022 12:07:42 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21HC0dLs163585;
        Thu, 17 Feb 2022 12:07:41 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2172.outbound.protection.outlook.com [104.47.58.172])
        by aserp3030.oracle.com with ESMTP id 3e9brc9wc6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Feb 2022 12:07:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QrbhRyfg8ydOc/n/tKYM/WbMb4Kpu1qDmdsfG+pUxB8Bh20WDuUIlGmDKvrcOQ3HqplPsLOrFK/Ig3jwauFwOpUUXcqhEaSj+1WYVw9XP55xUMODmMO6N4+Gd9cPNkEkXtaBThuKkvKAoT+tCZKTX952CmmBIER2WnZ5QwPzPIVOvjPp9walEtOsS2ebFoQ2cARE93V+N7Jg1nzudWG15J0iV0gi4brzl1Uzawi92MeVBBo+kHD7XdNqZZ6SmwhHnkKZy9lLAJT9s4GhNMM6J0h4sXMrelxVqBAH73FBdnIYzm+I0nyBHCx/UJAoTa/CoEi8uor2XQYCQgUcbdSrIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nKpPv/o/oIGYZJ/IhGUMA9JZVd1tqItJCW+GQKKHDV0=;
 b=fyUqixjJW1z22J9fggaBChQSPNxxtgeBJRmA5zwD6ghLGel/xIWTJwm+95ds8Gb8jYvrpjFYR5Yt/7zvfXkh8F1v2tCz0WHRhie/xdnrpCtTwscb/kkZTwJUlS1cwqvh0LANBbwIVo8fEbgYKNXMbK4bNh0+5Q1n1n/UdfOPYCgwAzucfURm1AMe6NFPiTaDiBpxnwI2J9KW2CSpGsiHm36MxdCieKs6GjuGIS/5CTrlViP1kKJisVPEwbrGK7IgL795bR+cUsElGe+INFot74JTLFwBnH+yM+hEP9DH7r5Xa8EAurIyKlpnuCMtDC9/e8aVzMo0TuG1UKUB6lhOxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nKpPv/o/oIGYZJ/IhGUMA9JZVd1tqItJCW+GQKKHDV0=;
 b=oFgA5oLiOF90qIyJ9GeKjGU7I3jMnH+vc1mZ2i86lMj+kxHYn+Y6RFdt9cUbhnpg4g5J11VoP8BfRsVPZMqmsFYd6cNXd3XXFtfPNOxrDUX28FDscoJLY6xHC0J0KjfozfCA4kWDBGEGf/XFnoMSxz53/4pDKiPFMi5jTc2lem4=
Received: from DS7PR10MB4926.namprd10.prod.outlook.com (2603:10b6:5:3ac::20)
 by MN2PR10MB3533.namprd10.prod.outlook.com (2603:10b6:208:118::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.15; Thu, 17 Feb
 2022 12:07:39 +0000
Received: from DS7PR10MB4926.namprd10.prod.outlook.com
 ([fe80::e429:a820:ef6e:98d9]) by DS7PR10MB4926.namprd10.prod.outlook.com
 ([fe80::e429:a820:ef6e:98d9%6]) with mapi id 15.20.4995.017; Thu, 17 Feb 2022
 12:07:39 +0000
From:   David Edmondson <david.edmondson@oracle.com>
To:     Leonardo Bras <leobras@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Chang S. Bae" <chang.seok.bae@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        David Gilbert <dgilbert@redhat.com>,
        Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/2] x86/kvm/fpu: Mask guest fpstate->xfeatures with
 guest_supported_xcr0
References: <20220217053028.96432-1-leobras@redhat.com>
        <20220217053028.96432-2-leobras@redhat.com>
Date:   Thu, 17 Feb 2022 12:07:32 +0000
In-Reply-To: <20220217053028.96432-2-leobras@redhat.com> (Leonardo Bras's
        message of "Thu, 17 Feb 2022 02:30:29 -0300")
Message-ID: <cunmtippugr.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/29.0.50 (gnu/linux)
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0232.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a6::21) To DS7PR10MB4926.namprd10.prod.outlook.com
 (2603:10b6:5:3ac::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f2ff970e-ec1c-4656-7e08-08d9f20e17b2
X-MS-TrafficTypeDiagnostic: MN2PR10MB3533:EE_
X-Microsoft-Antispam-PRVS: <MN2PR10MB3533F1E51A1F190427AF2F3288369@MN2PR10MB3533.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sw7+vLA31CpI/dvgnumKJ0ltZpDQSGhI/kp5bVf7Ny0iPBLQB+cuUHIbBsSlB3WJ/bx8QFm/ckeeJt+0yNAwI0OkHp5RZsOIeINoCUFkPygcodPzx+bZDRrARIS143aS5oeWDb706mu6STZ9GFFr6MwIdBFvq0T0MO9sMm5Z44NdcKfAamgF3lpW9AJ3HJNKMv1Z3yXjgdHvKTHg0RlHLZNEAyj3/NBb+7iLHuDv0C8HuodJ3TrM9REOgOrm0/dTfWgxP7wktEK+Lo/NgazCjXGMIRlDkvLLH5LIHyCcW1b4JZRmOAx/iVLIz3BJ3sVEF07+i59ikMvBx5oAibaF+9PUgCFfNr4NSSmHaYKDBLwUyDoLGdWixIBRHP/PNduL6ldVc6O9Q2xcdZVa3tlW3g/TWACzzpWk0Vqzis/HGLdclOgRPDLG1GY7ekBnUTFY+Uyv0T/Mc2Q7J/nhiohkLlME0TvC9Ai+8uzUM/YzXbjuCXVNONDsI4+oNhVhhAdPmDx/t2nI62mBVilx3ngXbAZagBtRgl4myR8T0q3lW7PKlFAspepYvdyBUuaABKWxHoCfq/Z/LQgM4LCt5LCb7aJs5AB9D2JFKDuL804n46MSf2AYCRqjXg2zenQ0nvhhKuiqHf5ZNWDJ6RIQjxI1WlDVCK4BrayXL7PDvRuwdDh3CbGaVJH5noM513ohUQXH3wfs87FUoSIm0n6BDZYmnA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB4926.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(186003)(83380400001)(6512007)(6506007)(52116002)(66476007)(2906002)(38100700002)(36756003)(66946007)(66556008)(8936002)(6666004)(86362001)(7416002)(44832011)(5660300002)(2616005)(8676002)(6916009)(6486002)(316002)(508600001)(4326008)(54906003)(4226005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YXdbABjnHPd+yjw1eWNlOUYfrD4z1K3SMBIEiFBi9BzxFyIZwP2Tn90ZlvS1?=
 =?us-ascii?Q?+qwddDeHLYJnvt2+DXBPk/lQkZckMNyyRjC3nK7XbZaHtYFwCRUxp+UvMJ9S?=
 =?us-ascii?Q?c7ix5WI/ufzo2Oe8TrTj/VUveOEnfXoby8p9F9RaWqjWQIw21rMcy9wLxvNV?=
 =?us-ascii?Q?3wCB//fQ5zksxbbb75ZbPmEcWOoAbnUhbDlvkXJSFioUwsbXyR+eZeoXdjoG?=
 =?us-ascii?Q?El06AHy3dCQ12cy4sg2RBCeB6FrB84aa2LNMb1zw7JWEuDdTuBOx3v2GmvfY?=
 =?us-ascii?Q?Z9nABw9MO3ePV5UnUdnsFm8JXTsHNgvGjQCcgvlEPM/x7kjQwbT2CtI8ccUY?=
 =?us-ascii?Q?beZ5kp8BGrqiD90MVtKOR8CeHP/fUYyDa0ZIYwVPhPoK01dqBDkIfqmxR0sE?=
 =?us-ascii?Q?nvp+1cbwfeYps4QawqPd/pb5mQA1wJxCp6Ypn3miHa2upyCfOPXUkYfvyFCU?=
 =?us-ascii?Q?NObHQgNJkgNvsqBtYZOPswwYDePJ3xHuLqDo8IMKglKc1CRs4u093W5lB2s3?=
 =?us-ascii?Q?HqLrRsK2DlIchEH3agJ2QqLsm+aAnEyNowHtWeAN/23wMIAz3Kr4JMgxI8/I?=
 =?us-ascii?Q?hRkHP0FtCO9B25U4EjKLs9w4zzFAI85H4rZ1pdQATCOrMophTJR55UlN0Gu6?=
 =?us-ascii?Q?Jt7j4fpoYVtCNNUNmR5kkSrKrsnhmrRJgAF8vXOHIM+KUKliwhjZPepQuOvH?=
 =?us-ascii?Q?EyhjlyKYtOfNrbdk2r9PQ5/hBh2mo32VWT+MA3w4oQvVcf0U8agywv/4eypb?=
 =?us-ascii?Q?ULRMdd6hjECSr0yaxfMgp5cjo2TLFpkIneK1Mrs0CbnrxoTPqNgsblWC9gu8?=
 =?us-ascii?Q?rseMDwXMI+1zAYmW41mTBlsOMgqZNwP2frxqnsomN3VVQOB3TrDJyq+5elsV?=
 =?us-ascii?Q?E9FaHIa3QWui/TkMCSBA6JcMvBmTzCraZVbkHPbl5CwlBlgsIo0omt29rnZF?=
 =?us-ascii?Q?2TPKF0AMAuamiY6XXItWQp/1X2XQVSs8OAFsT14Q+1BT6G3vcLpeRsQ456tW?=
 =?us-ascii?Q?aO2EBwB90cVgc/mSlZoTTh1C/uFVRX8/wRWVCgZzLRzUXRoceju3/5qRCUh3?=
 =?us-ascii?Q?SNXUwiXz/pYpAbQys/ReUH4RF8ws4ymuOkaB5MiWmMtMpOH61qYFLa6do0Rc?=
 =?us-ascii?Q?OEce7ojV0I09Nw/wN6xCztJ9wOHNAKcIhCUgBEZPmDKDlTBnQNGwMVBLH4N5?=
 =?us-ascii?Q?0lRLowdOaNK1SE5OQa2Ng8KFhAOOm2ZgbpbJWbUEfVMU8CHvi8WY/jpMHNWV?=
 =?us-ascii?Q?RAVr5sTcceiWWytPYP5YZOgFuAzczQujlNX3BuAeyJtnOp1Nmjy3t0v99HMV?=
 =?us-ascii?Q?CCuWDkHrwKHnMcm8r2nYXihzIh3lN4X4df1r6vgcsDJiOirEKlKyTn9x5x3+?=
 =?us-ascii?Q?hteeiv8IY2+fWldc5sUQjZxDWOzavd3EKKXjSBXfhcPZL26zyhQ9FedHTAVi?=
 =?us-ascii?Q?BfYZKEMn/Cck9MU6EjVn+7X6XVO7ezPlLn09jNRSXHTmiebLUU1C978i7NZE?=
 =?us-ascii?Q?rHZ4+4qQjlfuTa+WjVOyRW1cV+r8oRuHgzh9yfrbcT2UmB3S3ldMmw6IvllI?=
 =?us-ascii?Q?VLJpXr2kWHqVN6cVRnKR1IWZxNdP7meajYtVjxpG81GFQcpSdOT52eo4Bgf4?=
 =?us-ascii?Q?/hCXzpT9QehIa23jXuuTazmerYKSef0Yd0Z3F/YYizKNM2h5ekOp0rVe9bHU?=
 =?us-ascii?Q?EBVvPZt0MQV1a5m8WCsNqYy8QdY3NUax2AXCh849zLQpwvao?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2ff970e-ec1c-4656-7e08-08d9f20e17b2
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB4926.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2022 12:07:39.1923
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yjJT4ljho7+EpqFSPvfJeUH+BYrf9tBFF/okj4s0tlk87P76Sztp8SVrzfyKOTBWt9h3B+7MXmMKXONvGGdBl/znFTUSH0GWZdkxVGB36Bc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3533
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10260 signatures=675971
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 phishscore=0
 suspectscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202170054
X-Proofpoint-GUID: 29Npygn_LMhsaU-a3UmgljZjRHiERJmW
X-Proofpoint-ORIG-GUID: 29Npygn_LMhsaU-a3UmgljZjRHiERJmW
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The single line summary is now out of date - there's no new masking.

On Thursday, 2022-02-17 at 02:30:29 -03, Leonardo Bras wrote:

> During host/guest switch (like in kvm_arch_vcpu_ioctl_run()), the kernel
> swaps the fpu between host/guest contexts, by using fpu_swap_kvm_fpstate().
>
> When xsave feature is available, the fpu swap is done by:
> - xsave(s) instruction, with guest's fpstate->xfeatures as mask, is used
>   to store the current state of the fpu registers to a buffer.
> - xrstor(s) instruction, with (fpu_kernel_cfg.max_features &
>   XFEATURE_MASK_FPSTATE) as mask, is used to put the buffer into fpu regs.
>
> For xsave(s) the mask is used to limit what parts of the fpu regs will
> be copied to the buffer. Likewise on xrstor(s), the mask is used to
> limit what parts of the fpu regs will be changed.
>
> The mask for xsave(s), the guest's fpstate->xfeatures, is defined on
> kvm_arch_vcpu_create(), which (in summary) sets it to all features
> supported by the cpu which are enabled on kernel config.
>
> This means that xsave(s) will save to guest buffer all the fpu regs
> contents the cpu has enabled when the guest is paused, even if they
> are not used.
>
> This would not be an issue, if xrstor(s) would also do that.
>
> xrstor(s)'s mask for host/guest swap is basically every valid feature
> contained in kernel config, except XFEATURE_MASK_PKRU.
> Accordingto kernel src, it is instead switched in switch_to() and
> flush_thread().
>
> Then, the following happens with a host supporting PKRU starts a
> guest that does not support it:
> 1 - Host has XFEATURE_MASK_PKRU set. 1st switch to guest,
> 2 - xsave(s) fpu regs to host fpustate (buffer has XFEATURE_MASK_PKRU)
> 3 - xrstor(s) guest fpustate to fpu regs (fpu regs have XFEATURE_MASK_PKRU)
> 4 - guest runs, then switch back to host,
> 5 - xsave(s) fpu regs to guest fpstate (buffer now have XFEATURE_MASK_PKRU)
> 6 - xrstor(s) host fpstate to fpu regs.
> 7 - kvm_vcpu_ioctl_x86_get_xsave() copy guest fpstate to userspace (with
>     XFEATURE_MASK_PKRU, which should not be supported by guest vcpu)
>
> On 5, even though the guest does not support PKRU, it does have the flag
> set on guest fpstate, which is transferred to userspace via vcpu ioctl
> KVM_GET_XSAVE.
>
> This becomes a problem when the user decides on migrating the above guest
> to another machine that does not support PKRU:
> The new host restores guest's fpu regs to as they were before (xrstor(s)),
> but since the new host don't support PKRU, a general-protection exception
> ocurs in xrstor(s) and that crashes the guest.
>
> This can be solved by making the guest's fpstate->user_xfeatures hold
> a copy of guest_supported_xcr0. This way, on 7 the only flags copied to
> userspace will be the ones compatible to guest requirements, and thus
> there will be no issue during migration.
>
> As a bonus, it will also fail if userspace tries to set fpu features
> that are not compatible to the guest configuration. (KVM_SET_XSAVE ioctl)
>
> Also, since kvm_vcpu_after_set_cpuid() now sets fpstate->user_xfeatures,
> there is not need to set it in kvm_check_cpuid(). So, change
> fpstate_realloc() so it does not touch fpstate->user_xfeatures if a
> non-NULL guest_fpu is passed, which is the case when kvm_check_cpuid()
> calls it.
>
> Signed-off-by: Leonardo Bras <leobras@redhat.com>
> ---
>  arch/x86/kernel/fpu/xstate.c | 5 ++++-
>  arch/x86/kvm/cpuid.c         | 2 ++
>  2 files changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
> index 02b3ddaf4f75..7c7824ae7862 100644
> --- a/arch/x86/kernel/fpu/xstate.c
> +++ b/arch/x86/kernel/fpu/xstate.c
> @@ -1558,7 +1558,10 @@ static int fpstate_realloc(u64 xfeatures, unsigned int ksize,
>  		fpregs_restore_userregs();
>
>  	newfps->xfeatures = curfps->xfeatures | xfeatures;
> -	newfps->user_xfeatures = curfps->user_xfeatures | xfeatures;
> +
> +	if (!guest_fpu)
> +		newfps->user_xfeatures = curfps->user_xfeatures | xfeatures;
> +
>  	newfps->xfd = curfps->xfd & ~xfeatures;
>
>  	/* Do the final updates within the locked region */
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 494d4d351859..71125291c578 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -296,6 +296,8 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  	vcpu->arch.guest_supported_xcr0 =
>  		cpuid_get_supported_xcr0(vcpu->arch.cpuid_entries, vcpu->arch.cpuid_nent);
>
> +	vcpu->arch.guest_fpu.fpstate->user_xfeatures = vcpu->arch.guest_supported_xcr0;
> +
>  	kvm_update_pv_runtime(vcpu);
>
>  	vcpu->arch.maxphyaddr = cpuid_query_maxphyaddr(vcpu);

dme.
-- 
All those lines and circles, to me, a mystery.
