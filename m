Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1ACE078B4DB
	for <lists+kvm@lfdr.de>; Mon, 28 Aug 2023 17:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232174AbjH1PyZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Aug 2023 11:54:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232531AbjH1PyP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Aug 2023 11:54:15 -0400
Received: from AUS01-SY4-obe.outbound.protection.outlook.com (mail-sy4aus01olkn2189.outbound.protection.outlook.com [40.92.62.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6ABEA9;
        Mon, 28 Aug 2023 08:54:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ABkx6b8UGd5SvN/YbzsG3hThKi2K5DWWfd5RQ1i+dxeujq6JSD3/V1hLEmNuIkFTI+ZNIT93MKjNxK/pccpYjWkYaC96L6ito69fpsz3LNBgznEuSMsIz6goFYsRz3JOMrlVJSfpWPEobxrxyEosgAiLJRBcygasFtUai592wUKkFLKu1n24bNcIlYeiHpNBGtBdydQNaDamkYICIkQhKAS49j0q88uhKrGW/NlAxIOmw7t8qJXdk7OhZXtVdntPkvDGgVWqVQc9MPFrrF43+lvBneOTJSvmnKbSf7zEoDK9I+VQLK0C2Dme70UI1g2xKnIk2A+B/kGrQaIqvIn1og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HFpLYinOaz02l0fsvNkmbka9CHbo2Zl6dluGFzsvDTc=;
 b=kPtwW+3W1iTnPZz/mw8NNi48SvYn0vAABA48vHDm1+A8P3ny72UJoJy7rDCpYVZRMCC0P6R0nfskHJd3/m8nrsMCCBbmoRGddIvk8gKPOhiwHcHIX47pCA7FXcKFjuo/Els0YISuxt6t/z1OIiGe/NC/iirN36wWaa/d6KukipmdLpxIMMN8xP2BPl8UrhutiU0EHqBf4T815kSdEpAmRrql3Ok7/G+2QvgpAOELfY00QEDRihcwBZEYsRKFKqjs3L3zIfTcMEJwJcwClklamQwGCNcGsVErOjjPyy1Pdj+neRHoYsrDzpkSnjfEjz6Sy8oqFbQRFYWw6VLvD+BY+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HFpLYinOaz02l0fsvNkmbka9CHbo2Zl6dluGFzsvDTc=;
 b=HirTKbJ0F9GZwG63Ltf8/3Gl3aImpBLCRUsXkOOs5jeLAlRpU/vOGm/Q3QxT/hItAIRb4/FqnJEHMiXnO/iGiHJ9pKg4E7r+nJ9AsLROpoWeF8kLwcEI3oZ2UK/bfKnTHKLEu6miEIWnP8Oi5I5nnA/qlxUf8+yJf0gXcTGuS1LeKo9GIvX473iDu1BNjiHzr3LuUmlf3nU3WrHg2D/fYF4RB/rhJ4memobDUf3s3ZAllff4CeOVdP4FCpHYVw6Kp/nLXbSv5TirY2XTBiZiDOTpJYjlse0NFZK6UCqgctLL5VFxD1vmnEoDwz+rYUNU4CUQ4Z0Qk/FeK/KTA7FETA==
Received: from SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM (2603:10c6:10:ac::13) by
 SY4P282MB0972.AUSP282.PROD.OUTLOOK.COM (2603:10c6:10:b2::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6699.34; Mon, 28 Aug 2023 15:54:08 +0000
Received: from SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM
 ([fe80::62ca:cc8a:e3db:1f2c]) by SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM
 ([fe80::62ca:cc8a:e3db:1f2c%7]) with mapi id 15.20.6699.034; Mon, 28 Aug 2023
 15:54:08 +0000
From:   Tianyi Liu <i.pear@outlook.com>
To:     seanjc@google.com
Cc:     i.pear@outlook.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org
Subject: Re: [PATCH] KVM: VMX: Fix NMI event loss
Date:   Mon, 28 Aug 2023 23:53:43 +0800
Message-ID: <SY4P282MB1084112AF3101FE83300ABFF9DE0A@SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <ZOypc+LeHdE5u0MC@google.com>
References: <ZOypc+LeHdE5u0MC@google.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN:  [Vh5C6t3BRIIWMWz2Uu6yi+ABQbqfbJi0CV5diqPuY3gc9waoo5ufuA==]
X-ClientProxiedBy: SG3P274CA0006.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:be::18)
 To SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM (2603:10c6:10:ac::13)
X-Microsoft-Original-Message-ID: <20230828155343.1104-1-i.pear@outlook.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SY4P282MB1084:EE_|SY4P282MB0972:EE_
X-MS-Office365-Filtering-Correlation-Id: 37386132-5a43-4d1e-1417-08dba7df0353
X-MS-Exchange-SLBlob-MailProps: a+H6FLLcF3oYXq3i/jRYExuHcFa/Noye+BzkwC2ie2xaWNTcAHl1w+jVcjH94bpAx4Ua3TsQXgTsIG7XDtEPAj9FBvCAnp1SL3Ho0OY9CtakxBpXxG8VFNAKanmkhUk3kfWXqrBjbh+6WwCQKtumuVAVGbbb9XMxVzR9rE33obIOAxpYtqLauL6FwOPvxvFsE6VVHTBa6C4mNAQRY/lGG/WPRFp6Fpmyz/ObgR27gKT8SoFDVzGzCVrcQR8TjQQEVP0CWyPhHbUb2WL7FmU7u3hRrY8eVEK10yYDtzchTtKxdkMyfNLJLZ4LzowjD4f3Ralh1o1CTILKM0RcQfD88Ooyg4E87UoaOkNlxwYCvJmRAwnuZ/qIxgK3olUOTV3B+EnOJ2w+fx6aMM5YKr6treAYGXwDOoN61cd9iF+oTX3Wq8Q0Du+GS3rtxat3q8S++BJd6dDKbXB3kLhI4xS6FXbFhzBh2SP2vFo7k2VSfQoavkj51RgUQ9t18/7G8x54dbvIzm0Cfjjr6nZUCJMEqTC9Ef6njLvM0UbKVUWO3bXdYF6oHT/dAbrBylMOjqyCXQhXCmvm2NSRafzFJuRnMhU9/ENepgVkQT1mKSKnhn1EGivuFHtw6QGzhDVOwa2Srvq1d1jmG0jet2LJnEPQfQtAKQrnm+OqliHU78uImm2dRUmHb+E7Rqv6W+Tt7XxRLX4Pyvn9bijm/228pHd50jiWehsqG2eAsgjDRA3U0tpzcpdQQRHnJ4laI4RHNd7Df3dxCNsl6NFcat7SwCvpWFK9uNyMeAA2+x+HtiIE9WBDU+2VzjJjTeFbHTO0XClM
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ElLOobeJV//5Rz44qC/zz0Rf/bEKJVkB2J2cqYEaal6HYIQRkG0EqkRXhezsyY/Q7v6r2ekzpVPsneLKtLhhdv5IHFq3hFiE6YpxRGvadFy82H9j8qqpLpkuyYg4Q4F5asoixlqQXeUFyGGKOb37LcxtSsyVAh7QYcISS59XT+BKu8DDWFnAXReBrnBPf73bebDe5t1oDzbr9ooBNQ0vNOx0zM2U4nwrEA7b6e2/BOFdvWJC4ntfjcSu1ABvOYrgI7AiW8tHPrIxkr8rV/v9gRRZBXYwPNkGP93YqKPWBa6ISMOuOAZv+0wJwNsu4bTV7U+GTdg2trHhUqPA50nSL6kMK4aIB/+CeK2L4wtqDdFla+OJ7OjXaWIbRlG0w8yqdaN9oJ9hEjK4OhTbhB7bdKXIgViB+w20PVH+kYLRePPDdSLrtTHcz7RQTmi0GeS3QRUXNKVK3ygq4uzq7A9jRF4CDgGrVhu3DQffTglLhJoriApdmyd7SzGyi/BgPCRzaStxRyUa+GRwvC+i5ozMDIY9ONU1GLDvJrjDMpb6/OwtHuvzyeWPdASeJB9m2hEED5J7sm3rxD+ciDJXMbh5QNaluBSiciSYVk5NL9iVNRs=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TzJV8w049an0oyQ9nmfsZcaqjnBxnBVWIIpO/Ee9KcvtfsEWFe/ikjUcJ0xq?=
 =?us-ascii?Q?Dsj7zBt0xjAysXt5SbJ45v/sxQeSzBI8FGDxqZ5jsN90kmPZWTxYHxb0HmRf?=
 =?us-ascii?Q?gnVt9DJh+067vU18Sh+BOdyqsCoaynRCEhJxJwvmfHTQpF3HM2T63JS4UZKB?=
 =?us-ascii?Q?YRwwEB1zO+8PDmBO/uEIf9Iolo2L4rbxD5M3iqQdTw+1/nqR0V2SAaI+90zZ?=
 =?us-ascii?Q?SJ0WqyfUt6Q/G1yrNlpbAZHJcRZwmnoZ3jVfZcALob6PRdRQKWWotJoiuyZk?=
 =?us-ascii?Q?WF2LEG6G4xG49RwziVRq6YE1bY6eiXP9/49Gy7mgzua7KKbRR9ikkkx+MHSj?=
 =?us-ascii?Q?muuVljzx2vy9EnJhkzkz0E3uu2ieqMxZa85wynVB0W68kMfr9fpX9ayz5vRU?=
 =?us-ascii?Q?NdkDPzGa4xpiOpBRhFkKmJ2tgfMtt3Llj5YechcrLHFMV+afP91+FK8LTWIZ?=
 =?us-ascii?Q?OnExjbPqoij1vBNcpGhPg4YhA9hPuI1wX/wilm9KyHpairNrJbHYTpZpCoFi?=
 =?us-ascii?Q?RpQZmHfeJ0W8vGWBI2QyXjj4vaaY4kJs8G6rWH/QxF4rMECbCqcCK5jaX2RN?=
 =?us-ascii?Q?OlkudeN5ifSakUvW3hfOYGRrN5EINKKpru3/2mCPdp2/AaFm6221rxQjPT5w?=
 =?us-ascii?Q?WEcBK9YIdx23rhjWu/UMIocm9hvGcslD/tv0ikVpxgiHhWZv0lT83SmgEyZa?=
 =?us-ascii?Q?jk0VvDtjwD/o0JQMYISxk8yU+eQ4IcmMLcQZPvCrSAisreP3RUu+B4jBnJT6?=
 =?us-ascii?Q?ddzlH7PujSLJ526siwT0jL50yqXsFSCpMwQpQ+4TCLCFd7DnD8HXR8v+05up?=
 =?us-ascii?Q?iz47Fd2PoSNcmPIdMaQcEzTkWBxQlyWEN11fc8axRpcuHf2JVBg0iqFTKlrK?=
 =?us-ascii?Q?cc7Z08OT7lV6w4it7JHbJuv0p4L+AyvQSVN3WPa18ID7hDiQmJnhZ201q2vH?=
 =?us-ascii?Q?ZPhjLrmpoPHHtceM2vXQ3cbIIAaJ0Olh+30n5NH3JieydOkd3Nmc9S0gjeSg?=
 =?us-ascii?Q?ZySvxC7lf5t5PtrUm0ELpRl2WIurnbS9oNbY17QpfGveKVAL26SqGR2Dsc7M?=
 =?us-ascii?Q?/KioXevFP2TOTOyuOKmIwq2HPbWs6aN+QCm4xjoVxZLpvsISzU2SXt3xXKx3?=
 =?us-ascii?Q?h1sRBQZ6m6hDKCsCq5vH8GEw1sWx9fGMsnB0NgAiZditdzPi20OVIWzAN2H7?=
 =?us-ascii?Q?awu5dPCwJvDQ9mR4qX1+1CtX1JdlV8I1xkP+PEVqNS6KvcBWwjSjZzd1qcfV?=
 =?us-ascii?Q?hTHhF2MXmI6htpXX156I?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37386132-5a43-4d1e-1417-08dba7df0353
X-MS-Exchange-CrossTenant-AuthSource: SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2023 15:54:08.2535
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SY4P282MB0972
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 28, 2023, Sean Christopherson wrote:
> On Mon, Aug 28, 2023, Tianyi Liu wrote:
> > Hi, Sean:
> > 
> > I have found that in the latest version of the kernel, some PMU events are
> > being lost. I used bisect and found out the breaking commit [1], which
> > moved the handling of NMI events from `handle_exception_irqoff` to
> > `vmx_vcpu_enter_exit`.
> > 
> > If I revert this part as done in this patch, it works correctly. However,
> > I'm not really familiar with KVM, and I'm not sure about the intent behind
> > the original patch [1].
> 
> FWIW, the goal was to invoke vmx_do_nmi_irqoff() before leaving the "noinstr"
> region.  I messed up and forgot that vmx_get_intr_info() relied on metadata being
> reset after VM-Exit :-/
> 
> > Could you please take a look on this? Thanks a lot.
> 
> Please try this patch, it should fix the problem but I haven't fully tested it
> against an affected workload yet.  I'll do that later today.
> 
> https://lore.kernel.org/all/20230825014532.2846714-1-seanjc@google.com

This works for me, thanks.
