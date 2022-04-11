Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 451134FB259
	for <lists+kvm@lfdr.de>; Mon, 11 Apr 2022 05:28:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244565AbiDKD3V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 10 Apr 2022 23:29:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241110AbiDKD3S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 10 Apr 2022 23:29:18 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10olkn2013.outbound.protection.outlook.com [40.92.40.13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 910D13057C;
        Sun, 10 Apr 2022 20:27:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=efYfGYjpXfh2Axs6xdkr6OuQRlVTsSAm/+aB/dslFT6u0O6Ky8xoU1NpFxf+goG7+28SY08YOBFLTLllUdtiLkI2xlnRU+tSsdVcRRWPRklJKJWarsK/LziHSNNF8bdFiRDhdYMDmZGG1f3TfVIOtBl7RI2NFN+UZCpE7o8P8wSvxWK+AyVOHDxvoOXRdQsYY8oz13/lganLImB03fq0mJoQ46JxlWrZY+IFleB7tkP2xmYymBMpq91dUPBiG2kvYPi86Im7gdaHm5rmBk0IPHGcdRqZ+3cgGLTGYRWHiycMgnA5igTjxc64y/6K5gKeCxFnuJu8vvJE6crX6nFDFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yXHWunt2UxfmPRv5vMJPPUtZOSDKP3pPNp5pWAVrMpM=;
 b=gGYVdllPgkyQ/VxLHnOezfl4+h8QT8/xZ0S/ZV72Z19aJX/Uc8Aaj30DWALFFzh37Egdpr0zI63c9546x/EyeEHscH8MGLrHLHEvWk3w+iKKsROSbWJL39zdq/EpnCve5DX3p/cMERHtld6ukJ8qsddzq4q1dDm/alojWQGo6sRs/KC+BfbAodd1Jyg2Tvx48OcFQ8EBoZmBRXX4aw9/6I9L+krfOHA0za51N6Mo8vnWvSFhcLhwdlQ/zCs+OQhZrXNrcZB+l5qi2Ib+5ml/fvqa7FkBNx5r45tqdh4TnfkBuUe/QB7EIZrZkMsfdrgun+dtkGAEC8b+X9PWNjcgwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yXHWunt2UxfmPRv5vMJPPUtZOSDKP3pPNp5pWAVrMpM=;
 b=KNiBac+/CPCMid6bbgqPJXfbxlm7ZxCxqPLQAOkH+9lqpPNljf80kniCBB9F15Ds8mdmEFCdnB8EyKaUvjBuNvDhUSx9uCMDZeN0epQ3VCmzXENLZiJbaRcPdWWeWKQ7UP8Fmc9UP41z1UiNe+OEAFUVkGtdmmZI+4gSTr6gRavdDyecuCq6/v5mgISnDPm0tjbNNTG1sHvPigwhmQfAsSLtXX/N6RbtI03ct8IscY+mhRl2ldju/YuteZUeYqB1fxpAeK2mXQBt5Gxx3Zw/WuddH1OY37VMK21abu2QdZ18kbaIoJ1y5OKLpcq8eCwt5NqO979pNAMiYArX0Te5Gw==
Received: from BL0PR04MB4514.namprd04.prod.outlook.com (2603:10b6:208:4a::10)
 by BY5PR04MB6374.namprd04.prod.outlook.com (2603:10b6:a03:1e8::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Mon, 11 Apr
 2022 03:27:02 +0000
Received: from BL0PR04MB4514.namprd04.prod.outlook.com
 ([fe80::1a1:66c0:1a0f:db48]) by BL0PR04MB4514.namprd04.prod.outlook.com
 ([fe80::1a1:66c0:1a0f:db48%5]) with mapi id 15.20.5144.029; Mon, 11 Apr 2022
 03:27:01 +0000
From:   junaid_shahid@hotmail.com
To:     alexandre.chartre@oracle.com
Cc:     dave.hansen@linux.intel.com, jmattson@google.com,
        junaids@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, luto@kernel.org,
        oweisse@google.com, pbonzini@redhat.com, peterz@infradead.org,
        pjt@google.com, rppt@linux.ibm.com, tglx@linutronix.de
Subject: Re: [RFC PATCH 00/47] Address Space Isolation for KVM
Date:   Mon, 11 Apr 2022 08:26:17 +0500
Message-ID: <BL0PR04MB4514EA108E4B39E698A99E9AF0EA9@BL0PR04MB4514.namprd04.prod.outlook.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <0813c9da-f91d-317e-2eda-f2ed0b95385f@oracle.com>
References: <0813c9da-f91d-317e-2eda-f2ed0b95385f@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN:  [xLsf02asB4b5niZtkkMNK0iH2bfSXuYc]
X-ClientProxiedBy: ZRAP278CA0018.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:10::28) To BL0PR04MB4514.namprd04.prod.outlook.com
 (2603:10b6:208:4a::10)
X-Microsoft-Original-Message-ID: <20220411032617.143957-1-junaid_shahid@hotmail.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a6e11da3-1db7-4ee7-9e62-08da1b6b2480
X-MS-TrafficTypeDiagnostic: BY5PR04MB6374:EE_
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BTsltVGokw5Ixql1WrKofAWnJlVvLP2bj8JsXLgYITkqTDm9Nx+m10bjNXTJt5xu7VeOKhqCzKrT0z1tRN+5CXl+04mlYqUr3iMPcf/kkKTM5LrLS2XDNj7z6+tIzSM28Q7ACoTgRVQHaJtyASpYp/UDbwmQdb8rCg2uNFSEkXDyO06oTlyHhRhrcyF1i0iBpNLwx+QO+lpmunRBw6yaLPEybfdWlNFs615mCGTqLkDZfvLnQlKslkcHyAw3ayPhUS4DQ4uTl8/ICP1GT8ClKmHdJKQcFznbLpuYkTmv4JRMpgo4Bq55RnsyiItblKA1sqmATBz/NPOtR/MsfjUUyazBuioUPElHQK2y/l3rU6FARchYxf+wqQMAEw2PXR6/nJ8n6J0IDWGVTBmP3Us8OCAYkMLF2rrtAhOJQ7QQ+BRVKkj1ksp6diWNEmrhr5i3gkCarMkXu0W0ahleS1a8Q2joa6mdH6MLjUE0eK6AuhZF6OSai9VCHTuOZOsTCC6oMkNdIu4Za4zTleNfEU33dN6ZxeuuEgytRgQQVHUUDPF6KXdR2+uitF3/FFeuV/Lva7Nhs8W2LMwXTNzvkbK9qw==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?f6NvEDARcp2DLz8luR2Kh2OikG7ZlWWZTwh7V1BDn98M1lu3OafW68kVTLu8?=
 =?us-ascii?Q?mUmj3CCB+8DtjbCGxA3VR+5fnwQosf/MdWwYT9SxTBrgU7nKC6P1h7/BLPYk?=
 =?us-ascii?Q?BIGWq3sY4Ui+MnzMLi2mdGm5csdGQo1/wqgY9LqJs14NVSY/0fOwL3q2esrS?=
 =?us-ascii?Q?hj0kj2pkwYRDhsU7CFPmTAWspo67B8VxS9Cjc54Atz1sGZ7L9nUp6tJOL8az?=
 =?us-ascii?Q?8Tr32/CuT5oIkMwjTJ7qiG6DTnvq7X1y+s2iqi5FCq5zhW0VGp8ppvnM7tTe?=
 =?us-ascii?Q?M2DOgD+F+6pU4ea/uB6FhtzmsiGYTUaHkBwUDL2leJZLe7NQJD8qnZwy7Nmm?=
 =?us-ascii?Q?uiiRKPz0+59AQtKcjEyWkHQnaZ742qyb9T9+LUB9DgrI7mYyX1lxp2TGNoMu?=
 =?us-ascii?Q?2vuO3TOFfs+YeCOo7MvO1uLsTpgfIWXCVdDtiMqRBshGhitlxb7078D5xVr0?=
 =?us-ascii?Q?xnp0iF2OlLbC0/IMYLSNLNliF5wjlb/B2ZsmfRZlxqNowoXJUgLiZFpUIE2O?=
 =?us-ascii?Q?f7UYXCwNaV4goSWJ9W0ivzH0bZ46MEZn8uorgh0fS+mgsyaWqFQL3eWJXllp?=
 =?us-ascii?Q?BdwdCzvrv2UM/3Vb1bs9BRWhzNyl4z3J8bhAksjp+Lijlnaoz8KRQqxS1qKA?=
 =?us-ascii?Q?lRyq2uknUKkulrsCS18NOs5DzXYN1sYVXWXF/bJAkB85xinoIr+Baf1V1ulH?=
 =?us-ascii?Q?BdvXpQ/wiKfmCurpxhQdDof32Qesp+lZIuqrePi32wWWEfF96jlcJZWwFe1p?=
 =?us-ascii?Q?lW4VXUDZ5jszgzFHVNkjiNBxPC3VAb6/IIGWvxo5rD2usO1KYnLq8Pi/hIeQ?=
 =?us-ascii?Q?NdGXJZsJcqoyxgD+LEfh4KAMFOL7iEFHSe2q+84wJSV39pcr4Z2fc+NZuXp9?=
 =?us-ascii?Q?1H+JdgxxIt/Zfhcu9ilMvUqX7pXqYGgzM8TAPD6TzM7sBGkbXgXVT03q3rvB?=
 =?us-ascii?Q?pL68AqnwReDq0BrzLWcOLRe04IqQsTGUv9ieWJepIiuMdhaD7Bvi6Sw4QhXF?=
 =?us-ascii?Q?eu6mjHt2VLR/PJNY4WqGLKUCfFmztvIaYBb+aR7TGw8daGOIEuoGme0Usvwh?=
 =?us-ascii?Q?+p9EtJK73+UDfx9/0+01n8TcHCWR9m/Vq2F3PL3BXqsDupzuF4JQHo1QgKrz?=
 =?us-ascii?Q?wMvguKZ2igvn1wpOhhwkXeIoA/CS9dISKc3/qJKiZP5JSPcymuEV/3l3sAzY?=
 =?us-ascii?Q?5Zeexw3RQw5+m5A4tjHN4XXz+VYlBqUjRLBM4BT85Qag9eYSHUUnR6mC6Skw?=
 =?us-ascii?Q?65hGVIV7xpTFKQJszUrkRWtEatJal82c/w8b7+HUBCjYpv1Ln9dZbIwZw1oB?=
 =?us-ascii?Q?FMpJXeFbZ3ayhZF9BQJPJW7qMABqgVduRgBpAZztvU4OkaZVxHReeZOLfbbs?=
 =?us-ascii?Q?HYnKL/o0oLGED0hY8TTsEMRQwSeLzF6UYw8U8foXDG0iISqEdcN2DwSfOb9H?=
 =?us-ascii?Q?CXnzUI4ZsuoM9rzkhqWz2WEf23vvVCiQ?=
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-edb50.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: a6e11da3-1db7-4ee7-9e62-08da1b6b2480
X-MS-Exchange-CrossTenant-AuthSource: BL0PR04MB4514.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2022 03:27:01.8424
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6374
X-Spam-Status: No, score=0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SORTED_RECIPS,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

> On 3/23/22 20:35, Junaid Shahid wrote:
>> On 3/22/22 02:46, Alexandre Chartre wrote:
>>> 
>>> So if I understand correctly, you have following sequence:
>>> 
>>> 0 - Initially state is set to "stunned" for all cpus (i.e. a cpu
>>> should wait before VMEnter)
>>> 
>>> 1 - After ASI Enter: Set sibling state to "unstunned" (i.e. sibling
>>> can do VMEnter)
>>> 
>>> 2 - Before VMEnter : wait while my state is "stunned"
>>> 
>>> 3 - Before ASI Exit : Set sibling state to "stunned" (i.e. sibling
>>> should wait before VMEnter)
>>> 
>>> I have tried this kind of implementation, and the problem is with
>>> step 2 (wait while my state is "stunned"); how do you wait exactly?
>>> You can't just do an active wait otherwise you have all kind of
>>> problems (depending if you have interrupts enabled or not)
>>> especially as you don't know how long you have to wait for (this
>>> depends on what the other cpu is doing).
>> 
>> In our stunning implementation, we do an active wait with interrupts 
>> enabled and with a need_resched() check to decide when to bail out
>> to the scheduler (plus we also make sure that we re-enter ASI at the
>> end of the wait in case some interrupt exited ASI). What kind of
>> problems have you run into with an active wait, besides wasted CPU
>> cycles?
>
> If you wait with interrupts enabled then there is window after the
> wait and before interrupts get disabled where a cpu can get an interrupt,
> exit ASI while the sibling is entering the VM.

We actually do another check after disabling interrupts and if it turns out
that we need to wait again, we just go back to the wait loop after re-enabling
interrupts. But, irrespective of that,

> Also after a CPU has passed
> the wait and have disable interrupts, it can't be notified if the sibling
> has exited ASI:

I don't think that this is actually the case. Yes, the IPI from the sibling
will be blocked while the host kernel has disabled interrupts. However, when
the host kernel executes a VMENTER, if there is a pending IPI, the VM will
immediately exit back to the host even before executing any guest code. So
AFAICT there is not going to be any data leak in the scenario that you
mentioned. Basically, the "cpu B runs VM" in step T+06 won't actually happen.

> 
> T+01 - cpu A and B enter ASI - interrupts are enabled
> T+02 - cpu A and B pass the wait because both are using ASI - interrupts are enabled
> T+03 - cpu A gets an interrupt
> T+04 - cpu B disables interrupts
> T+05 - cpu A exit ASI and process interrupts
> T+06 - cpu B enters VM  => cpu B runs VM while cpu A is not using ASI
> T+07 - cpu B exits VM
> T+08 - cpu B exits ASI
> T+09 - cpu A returns from interrupt
> T+10 - cpu A disables interrupts and enter VM => cpu A runs VM while cpu A is not using ASI

The "cpu A runs VM while cpu A is not using ASI" will also not happen, because
cpu A will re-enter ASI after disabling interrupts and before entering the VM.

> 
>> In any case, the specific stunning mechanism is orthogonal to ASI.
>> This implementation of ASI can be integrated with different stunning
>> implementations. The "kernel core scheduling" that you proposed is
>> also an alternative to stunning and could be similarly integrated
>> with ASI.
>
> Yes, but for ASI to be relevant with KVM to prevent data leak, you need
> a fully functional and reliable stunning mechanism, otherwise ASI is
> useless. That's why I think it is better to first focus on having an
> effective stunning mechanism and then implement ASI.
> 

Sure, that makes sense. The only caveat is that, at least in our testing, the
overhead of stunning alone without ASI seemed too high. But I can try to see
if we might be able to post our stunning implementation with the next version
of the RFC.

Thanks,
Junaid

PS: I am away from the office for a few weeks, so email replies may be delayed
until next month.
