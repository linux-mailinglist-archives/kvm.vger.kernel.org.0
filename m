Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31DC569DB83
	for <lists+kvm@lfdr.de>; Tue, 21 Feb 2023 08:54:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233325AbjBUHy0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Feb 2023 02:54:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232710AbjBUHyY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Feb 2023 02:54:24 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 507B0CA21;
        Mon, 20 Feb 2023 23:54:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
        :MIME-Version:Message-ID:References:In-Reply-To:Subject:CC:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=horEw1Ol180UnAa3W3omtFjLGjpOZDMGdPvOLcP9j9o=; b=G4JsAhtzeSnLJ6Yt34kYxbIYgC
        h4fOfmktVwJt05bRG+toF+aK3iBVaCOAFPT/s4J0tsVAh9jRE7P1VRaWDyAXVtWJ0F3jpZRPI1kuR
        ljFQASq1xxDouOMVukyJS1cPPEkhO6pSiCXlTgJbuWtzSRLA16mfOaC9SYXswiYsHegPGaX9ylWL1
        mvBwt6g1B5wjQcVrf9dZJKc+pj9TpgW22M1/2t5Xk5PnoqCkvf5x2zTucDXJDP3W4ImdYTOaC9/gx
        oQLsIx6K0zlRE2oQiumCFhJk4O0uCxqiwHLWFSFLbywOXi95tcdSVdYxv1XSYkrY14BUnIZcU25rF
        3sCVst9Q==;
Received: from [2001:8b0:10b:5:e2f6:e182:83cc:f7e2] (helo=[IPv6:::1])
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1pUNTC-00C50Y-38;
        Tue, 21 Feb 2023 07:53:51 +0000
Date:   Tue, 21 Feb 2023 07:53:49 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     Oleksandr Natalenko <oleksandr@natalenko.name>
CC:     Kim Phillips <kim.phillips@amd.com>, tglx@linutronix.de,
        Usama Arif <usama.arif@bytedance.com>, arjan@linux.intel.com,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, x86@kernel.org, pbonzini@redhat.com,
        paulmck@kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, rcu@vger.kernel.org, mimoja@mimoja.de,
        hewenliang4@huawei.com, thomas.lendacky@amd.com, seanjc@google.com,
        pmenzel@molgen.mpg.de, fam.zheng@bytedance.com,
        punit.agrawal@bytedance.com, simon.evans@bytedance.com,
        liangma@liangbit.com, Piotr Gorski <lucjan.lucjanov@gmail.com>,
        "Limonciello, Mario" <Mario.Limonciello@amd.com>
Subject: Re: [PATCH v9 0/8] Parallel CPU bringup for x86_64
User-Agent: K-9 Mail for Android
In-Reply-To: <37c18c3aeea2e558633b6da6886111d0@natalenko.name>
References: <20230215145425.420125-1-usama.arif@bytedance.com> <2668799.mvXUDI8C0e@natalenko.name> <ed8d662351cfe5793f8cc7e7e8c514d05d16c501.camel@infradead.org> <2668869.mvXUDI8C0e@natalenko.name> <2a67f6cf18dd2c1879fad9fd8a28242918d3e5d2.camel@infradead.org> <982e1d6140705414e8fd60b990bd259a@natalenko.name> <715CBABF-4017-4784-8F30-5386F1524830@infradead.org> <67dbc69f-b712-8971-f1c9-5d07f506a19c@amd.com> <42dc683e2846ae8fc1e09715aaf7884660e1a386.camel@infradead.org> <37c18c3aeea2e558633b6da6886111d0@natalenko.name>
Message-ID: <5A3B7074-0C6D-472B-803B-D76541828C1F@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 21 February 2023 07:27:13 GMT, Oleksandr Natalenko <oleksandr@natalenko=
=2Ename> wrote:
>On 21=2E02=2E2023 00:30, David Woodhouse wrote:
>> Oleksandr, please could you show the output of 'cpuid' after a
>> successful resume?  I'm particularly looking for this part=2E=2E=2E
>>=20
>>=20
>> $ sudo cpuid | grep -A1 1/ebx
>>    miscellaneous (1/ebx):
>>       process local APIC physical ID =3D 0x0 (0)
>> --
>>    miscellaneous (1/ebx):
>>       process local APIC physical ID =3D 0x2 (2)
>> =2E=2E=2E
>
>For me this command doesn't produce any output=2E Also, no output from th=
e command Kim used in response to you=2E With no `grep` it just dumps a tab=
le of raw hex data=2E

I'll take the hex please=2E

>It's `msr-tools` 1=2E3-4 from Arch=2E Should I run this command on a patc=
hed kernel booted with `no_parallel_bringup`, or on unpatched kernel (if th=
at makes any difference)?

Either works as long as it's after a resume that wouldn't have worked=2E T=
hanks=2E

