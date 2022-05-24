Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 615E1532ABC
	for <lists+kvm@lfdr.de>; Tue, 24 May 2022 14:59:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237505AbiEXM7F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 May 2022 08:59:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231294AbiEXM7D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 May 2022 08:59:03 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F17527FF6
        for <kvm@vger.kernel.org>; Tue, 24 May 2022 05:59:02 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24OCYUhK028027;
        Tue, 24 May 2022 12:59:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=PzEyIAQCldMNfqJWngFH4OQs7y/YmmsWjVHbCSbAZmU=;
 b=vbFZ7BdxzUbgnNKGIbqcZY+QG6BaJZmOP5LXLq+XwnhtjnfxaPpK5CKCtAn2MNerfktB
 54FFBou1Xjlq+cRYXVJBOzElmNmd7Gf/eHMSs61Gs+R316OREEDnQGjMlA5Q4JM7vaAh
 OXLsHsiHtz7CREhBa3xkvHcN21rtIXV5uINVMV4aEEHorwZidJSAVtA6TVjd8VlOuR5j
 qjtvi+Wxv211s19gQd7UqmFnZMx0HtCcLykU9Q2EjWNJF1VNxYcYdIIBpqEVP1P06C47
 LCOJpGoZVxMjuUwq/9aGYUepDuxdWG/2qkWErA9Sk+ZjsTTcS4n1C+9Tne2s5qJBqyW2 QA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g6pv26dq7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 May 2022 12:59:00 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24OCwi7O029599;
        Tue, 24 May 2022 12:58:59 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g6ph2erq9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 May 2022 12:58:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sdtrl5svuHnDqYjJcA1h2FoeZFetwhyntO01rpaqRYvKmuWSPAMYwnZL9LVy8d1rUvoEJcYN60Vy5rvMn4lPgZFQ8PBx/9MyH+zzCFEa5GKJa8eFZeEbzRD/p7y8xvpxAk7a34kIyEbhVkgGeyQGSn4rdl6ODKGsIZ2PLPgnaRwXMC60pefHCu9WKgey7vnRKLtIg6IAJwirTRbiMTl2ZV/llnBGR3lPyZ9o/xQ3WD2wXq3lhRy8wC1DURlJmPp5LS3MvgU5r6MeUHtRc1OpvA4ezLSfQJEBCeV3SSWDAgzoOOr3wo+b8Q7iuInN26yJOYzX/fX6r3Aq+zQ8iyLuMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PzEyIAQCldMNfqJWngFH4OQs7y/YmmsWjVHbCSbAZmU=;
 b=ZChQNqVaXDZHU/Jrk7QeJS3JUvVFyUsj4wx0GwnVQz3zlgpvbWnImJ2KeiLB7k2Ele2ZPAq0cN/XGmyEpn7flScQ5iYhlqqyyQKqlrnnklFlsTZ3yAZ37Z8TM69opHvqPL/4FS0UC8NwSs7FWPsOGCU2eWuh0V7yTBZA3DQK0TcWjhWUCcXA7EYmRgDHwQ7WwUG7oXpTVEcwd6YqHnk+RPsxkuDhxpIdlxl93/AaniAfndg1CiYjlE0yOGXyLAVD/B0W102DjbdxbzHxWacHiLUTUoTR3HfvEnP/ro5pNhPMc4uL7sFARRiYAq9zj3oFuJf+Xx1fFMl3gWG2KH19nA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PzEyIAQCldMNfqJWngFH4OQs7y/YmmsWjVHbCSbAZmU=;
 b=EGuC6ph1LHAhZ2eoBrJ7bqU25KJAopMX1QRMdjg2KVWrQG9o7W382qhQrCt0szuNmM8q8ioMGDNLrwFFZA+wKXQxZ1FQyF00cO6OQQHgiOPcDruDvRlnhxsGVwRNCHZryVk2sweGo013969bdgccR+vOt1co3jt/+xfM/33jMAU=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CH0PR10MB5497.namprd10.prod.outlook.com
 (2603:10b6:610:ec::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.15; Tue, 24 May
 2022 12:58:57 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::86f:81ba:9951:5a7e]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::86f:81ba:9951:5a7e%2]) with mapi id 15.20.5273.023; Tue, 24 May 2022
 12:58:57 +0000
Date:   Tue, 24 May 2022 15:58:46 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     seanjc@google.com
Cc:     kvm@vger.kernel.org
Subject: [bug report] x86/kvm: Alloc dummy async #PF token outside of raw
 spinlock
Message-ID: <YozWhplb1iXiQDlI@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: ZR0P278CA0037.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1d::6) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 03cbb7ab-48aa-4840-4cc1-08da3d852a04
X-MS-TrafficTypeDiagnostic: CH0PR10MB5497:EE_
X-Microsoft-Antispam-PRVS: <CH0PR10MB54972D946B74A0C449B2217E8ED79@CH0PR10MB5497.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c2pDCxjwLsfmsMXBhDDOhk1J6GoYKi/dxIeN1RSm+VtkX9LZILPNx2tDhGMqdqnOZo7RHntzqJC3L/H9tHy5ROHzC9gn78ECKUlY7fMW3u5dNBwjqUTJy9ls68c0Eojw/tnAA+NG9vTHqN+CJkYomjXw4jyGfx0oPiutsXd/rgO6SGy25QKpjNbY5gk3CzMuBtFtvyZbOX1UsGlxWeqXP8/QXjMc5qaWGMtPVIDJ9qzc2g8pHKoyNpgOtTgR0ux6XlyLXLtpCALarxqDX2GpXG4QM2BMRFSlLl9npbSgeHxZCvxKszjHDqGP2UORwBXMbusqyInp9YizCMIIJJUkbw1oX3okv8CxyENG7uiaNvwUj1JLf6d0oyfzMiwWk4EcGMkEMAb9H9M4iz2gGDSHvQ29h3AO8CqLq4vrUwK9jtXVu3Lnz5h+GmSOgk+KvsrQGj8o5SOtnMRd+7Pcs4mjJiDHobYu6kKp0E7PdrAL5Ah4jT67miSV2EXkCDzoHJWrM59wyuX3Jjeu/dmb0zLUdskq9GM83DNGmhNjSb2qN+YumUw8EWoP4lotldQMMoi46Ry3n/kpOoNrVvgJ/asn4ZIsZkks7kDk67+8+rTVmkwWPBYocJhX5iE5vpwrtcI/i7TnWRzwNFXoffKX5ifaQIags/Q/sSQ4MmyLxXxMjjw9FTqtI7pD5Itm10+BfgK5hG+PEwGEJ9oCpV1yeHX6rQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(33716001)(66946007)(66476007)(6506007)(66556008)(6666004)(6512007)(9686003)(26005)(44832011)(2906002)(86362001)(8676002)(4326008)(8936002)(5660300002)(6916009)(52116002)(316002)(186003)(38100700002)(83380400001)(38350700002)(508600001)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3k5ojmxQnaC1/M9Rp3jbkWCyOlcFO//+LDq212N+OddKN5IPuGAWURFLhoER?=
 =?us-ascii?Q?CEwXSa0F/ERpt/vRNSpyEEu+kAnwpXiQBFy/Dr7TG4hHOV8jNX7ZaQTAFVlM?=
 =?us-ascii?Q?ubfA14i8sERD8EAVcfYxpxI+cWP5KxIl+NUdq572UCWhR+bIHRw+kXQPRvJq?=
 =?us-ascii?Q?XiXHGmv0n1dwsJhlZ6mxEyisTnwGj6LJCYx2fM5WG0hgJQBR33Y6OwDEUTcF?=
 =?us-ascii?Q?c0wbBXSF0ebjDGfHULHzLHyNe7stS8Sy1h8VWnM/uzpLG9DsKnHGHbEMm2nv?=
 =?us-ascii?Q?CGuUMVWiSvdreC5ei30rTbKo+Eick3Y8LdGLjgxolzwT47avGo3FZ2deBqQL?=
 =?us-ascii?Q?CSflvXaSOgwyf4MCucOFW65hy0YAC2BftXXFxgPUm36Q9HQIcF793lEyCFtV?=
 =?us-ascii?Q?vKndki6TdJUe9N7zXWUK5Jqsnuavnmt4sbsxxsaBWAadFb+wjRjREdHcpHUa?=
 =?us-ascii?Q?WINRlAryqxpyRmcAD7ffhU8VSuJA/nbkFx7YVZnstoB5NZNMzjwTLX0eSmw5?=
 =?us-ascii?Q?3oUVA/7a8tWA5tT3zlZGtmZxLvwutzhZA/E8lN3aiKgOgAIUccJFh1DAve8M?=
 =?us-ascii?Q?IYrRVVEQqRHBskw3VR0K6SE+6OA8tkxa8ZlOVOGm8Xa3PRmAQ9sHB1I2m5rQ?=
 =?us-ascii?Q?umFCDZTJbdAqLx/GSiwFSMXszhoWXhnJPbVjEooNkEF6Jf+Ne0igkOCMbiPr?=
 =?us-ascii?Q?fV1bi9hAYMH9DD4oFAM1kQaMAZWxpqnr25kzfQmZBtGzYQBzJODL95uv02We?=
 =?us-ascii?Q?9YnccLpj+hur+ep46yO7h0Hg6PicupiVPCbyT4rCJIhM+Z7GTMC/mUMlMdDX?=
 =?us-ascii?Q?/Emq+P82RGjSb3DTyNC1HJ256yT/yb3HM971u5z/6nzhBIpZMopxu7AD/GZS?=
 =?us-ascii?Q?wwGOpvFpq3odD4d3v6CfWzHwGfJ151aky8qbfXhZblD/90rTgZy+bvcVEpjR?=
 =?us-ascii?Q?wpUIfUsF0k7yp5XmTvoWRdTB11C2EcnSdAY4QdHmoYxpY2CEF3cmra2YAJs/?=
 =?us-ascii?Q?kQFQ+X2gxRm18yAmJ4ScHZ9Ta2q3o3aaIH+M9G18htv1uAVGIipGAHmkTXGA?=
 =?us-ascii?Q?zYvZVzNR/38pBQ5fhCI6+gXzYW1Gs5QUtF5F3jKwBaegu07hORL0gUmbSOZH?=
 =?us-ascii?Q?dLQoxenqPpCDYf0rl26Vd+UIiRJ47IZa6S/MYyUhKSiV1tUWV2olUQwPWKBY?=
 =?us-ascii?Q?Sk8YcEuNCobOE+6ZM8iM1x4TjZz1vdhpPuJ+SsD+ITxhcoBleciEuqrzIaLk?=
 =?us-ascii?Q?LVy6TqHq8k0TcUWOr7n+o5TAcMIkejm02jnCqXB9mo1aAqkYMdmyruW62lDg?=
 =?us-ascii?Q?CghlNQHUc62bNY2hcyCMfFcXGOdPCg8pYCa2UZNdF7N/BLuUlL3lIqX7mogy?=
 =?us-ascii?Q?qUJSs8JQqWLo/wxMpLY41Gl4ltdzSIKXAQtuWda35KQuT9wdHXA9EEWZ9ZEl?=
 =?us-ascii?Q?ThECKPhs7MTiz+ItAGMz2PFOs5wqNhRTWzYtiNhAECvtU1HTT4G9SFJmdOnV?=
 =?us-ascii?Q?clqsBXuT2D5XXLfiejdq+g5QX2GIsA3xyczH3Gy4CKTN7avziRXb6NL4EE/5?=
 =?us-ascii?Q?1En6WrjNhRkud0NovT0fL8trq+uQ7QoAD35snC7YZGlk7oeBw6Fcu2cpcJG3?=
 =?us-ascii?Q?/xUrWmQw7g0m1qHWJikTUsYp3iu+LvnHZIfqlZGibugw+KGRr4Wpmf6UFSHH?=
 =?us-ascii?Q?i55RIzrW6B+3YRppmWjlvHmiReMVozDzvzCRiDnUUQax3Q68YfOUm5CItEYf?=
 =?us-ascii?Q?KC521d4b80NEk+oyvjEi1SOTeBKzXGE=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03cbb7ab-48aa-4840-4cc1-08da3d852a04
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2022 12:58:57.2778
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TAehgqWnLUdSOWJ4H+nmmqWC7/qB00VDtZe55wsagaqYIjALYwwQ5KOuX1XU5udSzBS7ASxOubCaG3D/WFa9mxekPsnbXpe0CSVZ+iKJX04=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5497
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-24_04:2022-05-23,2022-05-24 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 phishscore=0
 spamscore=0 malwarescore=0 mlxlogscore=541 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205240065
X-Proofpoint-GUID: NjaAglBlW9zhrYR1EiQGT-gL8Ud6hYdn
X-Proofpoint-ORIG-GUID: NjaAglBlW9zhrYR1EiQGT-gL8Ud6hYdn
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Sean Christopherson,

The patch ddd7ed842627: "x86/kvm: Alloc dummy async #PF token outside
of raw spinlock" from May 19, 2022, leads to the following Smatch
static checker warning:

	arch/x86/kernel/kvm.c:212 kvm_async_pf_task_wake()
	warn: sleeping in atomic context

arch/x86/kernel/kvm.c
    202         raw_spin_lock(&b->lock);
    203         n = _find_apf_task(b, token);
    204         if (!n) {
    205                 /*
    206                  * Async #PF not yet handled, add a dummy entry for the token.
    207                  * Allocating the token must be down outside of the raw lock
    208                  * as the allocator is preemptible on PREEMPT_RT kernels.
    209                  */
    210                 if (!dummy) {
    211                         raw_spin_unlock(&b->lock);
--> 212                         dummy = kzalloc(sizeof(*dummy), GFP_KERNEL);
                                                                ^^^^^^^^^^
Smatch thinks the caller has preempt disabled.  The `smdb.py preempt
kvm_async_pf_task_wake` output call tree is:

sysvec_kvm_asyncpf_interrupt() <- disables preempt
-> __sysvec_kvm_asyncpf_interrupt()
   -> kvm_async_pf_task_wake()

The caller is this:

arch/x86/kernel/kvm.c
   290        DEFINE_IDTENTRY_SYSVEC(sysvec_kvm_asyncpf_interrupt)
   291        {
   292                struct pt_regs *old_regs = set_irq_regs(regs);
   293                u32 token;
   294
   295                ack_APIC_irq();
   296
   297                inc_irq_stat(irq_hv_callback_count);
   298
   299                if (__this_cpu_read(apf_reason.enabled)) {
   300                        token = __this_cpu_read(apf_reason.token);
   301                        kvm_async_pf_task_wake(token);
   302                        __this_cpu_write(apf_reason.token, 0);
   303                        wrmsrl(MSR_KVM_ASYNC_PF_ACK, 1);
   304                }
   305
   306                set_irq_regs(old_regs);
   307        }


The DEFINE_IDTENTRY_SYSVEC() is a wrapper that calls this function
from the call_on_irqstack_cond().  It's inside the call_on_irqstack_cond()
where preempt is disabled (unless it's already disabled).  The
irq_enter/exit_rcu() functions disable/enable preempt.

regards,
dan carpenter
