Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23E427D3E31
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 19:46:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230492AbjJWRqu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 13:46:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbjJWRqh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 13:46:37 -0400
Received: from mo4-p00-ob.smtp.rzone.de (mo4-p00-ob.smtp.rzone.de [81.169.146.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A55C103
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 10:46:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1698083008; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=jmiXr5GP2ZjYlGEzy99PwSu0Dxka28kaVNQWvIh9avSgqVT/uHyGXB3Y5aeEBo9gO5
    MOWPzmQoeQB9GKFwNcMNuvqmYMD6A3mtztEgfOL5aivWyVLWgxsvjQZxDsEtV+I0nWiD
    WQoCyvasBelQksWoEP0Y7n7VeFiQQ7vNiDCkhg967max4aqasxnnIu6pN9plYK2QC8n4
    TW1aO/LmWLe8+qYnxXq0kPj7W9gZPqkLCgsxy+w0DwkwKg9/Fy7z8J1TayKVaaqus5No
    K6cL8ABVkrDxmFy6He/w02yDg9VxPTgGmD5fUrXr226Z+Z6KZPHqpsUenUqo9kk2V80H
    AttA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1698083008;
    s=strato-dkim-0002; d=strato.com;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=PhNQbhZuZ4mNIKuJIeg1y/IipOz1IwFGMSPVtbq7ODE=;
    b=i6wqxzlkS2G6DAyo51IPEi5d4eUK2C9o/6dS7qZs4KOOhX1CelZektGuVasmWrxLQ5
    hGQImx4Bhfa2mqLHMysUOD5K2tE0GRq1Apem01NnFC0oHmC9ouT8UuI9K8ZCWrcO66Y4
    KZJEgwR5h9SsaW/RrxjA3nAbhCdUQBU1GslZGj5MbiSkmjtYd5ekvmFVnh6hA+Jk0ECU
    xlWZkyDncKRMsSCcgwkqVuskSOEmBUnr7TGBn4/cTp9hq7AWlUq1Al/ZjjicXfpv77Do
    yDfKOH9vLiKTr58kJ0KVpAVX0H8UY0t3tWwbu5iG8wtES5ZF7xZFwdGsI9/I1/wcSjLp
    pw5A==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo00
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1698083008;
    s=strato-dkim-0002; d=itsslomma.de;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=PhNQbhZuZ4mNIKuJIeg1y/IipOz1IwFGMSPVtbq7ODE=;
    b=DPH6FTbCqDmdek9B20HnDzk+HC0bIV1ddgArrtE75RUWyItQn1uEsDhr8dB6nEVKuz
    Uxbdsc+yUjP9eylTNlz9o6RUlS/f5hTZY+LruYhan5h9CGACFe2WgCkI/qM5ownslKht
    ZWqAUXaQi0JEHfWb6ViAGB0tCMJd/DrGYOzhmuVMPQnN2sekI/fxZliKNMiCTRIM4F6+
    QOeV+ChkZPhoOU8/nUh2LafrYrFBcw8cmmV74ztGi7WWs4L/IG27k/me9k/sc6lX8FQE
    TFCR/R8CidACoaDhNkUOHDcPsHWSkqSZJLWuRgI2fYCVW6bZO3aywJi53vEJqWydTSjY
    Vbqw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1698083008;
    s=strato-dkim-0003; d=itsslomma.de;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=PhNQbhZuZ4mNIKuJIeg1y/IipOz1IwFGMSPVtbq7ODE=;
    b=FQwfgptO30V4GNhWYUdamstb3XCzE474N04IChDpy0AXDngId36WnQXMJUO+iixKYZ
    9VstllwSRP4xHNwdTEAw==
X-RZG-AUTH: ":K2kWZ0m8NexQ+Y5NHnuAyP6+fJVZHx77D7CeOHU7oISihBj/J0bZiA5AdKGpnrwIizPqxHz0RPs4V+S71giZM4QZ/6yUw1U4CWhRxO0IVYOYOEQfPLs="
Received: from [IPV6:2a02:8109:b301:9000:de87:d577:37a0:f2e2]
    by smtp.strato.de (RZmta 49.9.0 AUTH)
    with ESMTPSA id z33ba8z9NHhSd7L
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Mon, 23 Oct 2023 19:43:28 +0200 (CEST)
Message-ID: <f9f6b30d-91fd-45af-8914-d2fad1c735f7@itsslomma.de>
Date:   Mon, 23 Oct 2023 19:43:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: odd behaviour of virtualized CPUs
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org
References: <326f3f16-66f8-4394-ab49-5d943f43f25e@itsslomma.de>
 <ZTaO59KorjU4IjjH@google.com>
 <CALMp9eRzV_oJDY7eD7yvcB9di8NzyTX34W8rfaK-wf2-8zQ-9w@mail.gmail.com>
From:   Gerrit Slomma <gerrit.slomma@itsslomma.de>
In-Reply-To: <CALMp9eRzV_oJDY7eD7yvcB9di8NzyTX34W8rfaK-wf2-8zQ-9w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Why?
As Sean pointed out if you have older CPUs that don't support a specific 
instruction set you need to restrict the capabilities in order to 
support live migration.
"this is expected" is a bit far fetched, it is not expected but it is 
observed and real behaviour.
I came across this when testing virtualized systems for performance with 
the sllr-application from primegrid which only ran with SSE-code (plain 
code flavour for me), not using AVX on a CPU that said to me via lscpu 
it was a E5-2660v2.
(This was VMWare for that matter and i wrote the test app i posted and 
tested in KVM-qemu-virtualized on other hosts).

Regards, Gerrit.

On 23.10.23 18:29, Jim Mattson wrote:
> On Mon, Oct 23, 2023 at 8:19 AM Sean Christopherson <seanjc@google.com> wrote:
>> On Mon, Oct 23, 2023, Gerrit Slomma wrote:
>>> Compilation with "gcc -mavx -i avx2 avx2.c" fails, due to used intrinsics
>>> are AVX2-intrinsics.
>>> When compiled with "gcc -mavx2 -o avx2 avx2.c" an run on a E7-4880v2 this
>>> yields "illegal instruction".
>>> When run on a KVM-virtualized "Sandy Bridge"-CPU, but the underlying CPU is
>>> capable of AVX2 (i.e. Haswell or Skylake) this runs, despite advertised flag
>>> is only avx:
>> This is expected.  Many AVX instructions have virtualization holes, i.e. hardware
>> doesn't provide controls that allow the hypervisor (KVM) to precisely disable (or
>> intercept) specific sets of AVX instructions.  The virtualization holes are "safe"
>> because the instructions don't grant access to novel CPU state, just new ways of
>> manipulating existing state.  E.g. AVX2 instructions operate on existing AVX state
>> (YMM registers).
>>
>> AVX512 on the other hand does introduce new state (ZMM registers) and so hardware
>> provides a control (XCR0.AVX512) that KVM can use to prevent the guest from
>> accessing the new state.
>>
>> In other words, a misbehaving guest that ignores CPUID can hose itself, e.g. if
>> the VM gets live migrated to a host that _doesn't_ natively support AVX2, then
>> the workload will suddenly start getting #UDs.  But the integrity of the host and
>> the VM's state is not in danger.
> One could argue that trying to virtualize a Sandy Bridge CPU on
> Haswell hardware is simply user error, since the virtualization
> hardware doesn't support that masquerade.
