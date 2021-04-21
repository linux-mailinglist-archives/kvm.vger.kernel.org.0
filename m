Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1114366716
	for <lists+kvm@lfdr.de>; Wed, 21 Apr 2021 10:39:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236392AbhDUIkL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 04:40:11 -0400
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:38277 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230250AbhDUIkK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 21 Apr 2021 04:40:10 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id A8CBF19417DB;
        Wed, 21 Apr 2021 04:39:37 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 21 Apr 2021 04:39:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=B+vuHZ
        SEBeP1MIHIlj5mpmizmyN0czTVssJhvmZQTrc=; b=nn/V7C9wa/NWZbltTyAdHK
        0BCgUhuUCBHuPofS/DhQR8QfrL+0VXKJagvrDA4fExN+kTabBTNXOcxf+Rs1ksO9
        ubQGWkHCf9qFb9QLuO366zkLZ5ZF8XtxkG/Jg1aYesu2EAo9QmBfkHshamC2oZI4
        0fI2M2C7ZZ7Lvwj5xYA3VjL/ua2cfiXIp8CRySVLe1UU/kYTv0Co9zSo52eCWmSI
        OkdrPfr4+YEQUWWp6atSVuAlACyxbjBAPEaJE5NozY1dG1PL/7+eWtB6YDupaQ2N
        s9XN6BjaKw56bkBeLNYRdj5/zkyrPdwa7DJ9yyme8xH85JPrR6fQ+mlyIRD3dycQ
        ==
X-ME-Sender: <xms:yeR_YNcpEI943SElU80-GC3j2eAC944NGGnxFZ98NtHMmXLbeU80IA>
    <xme:yeR_YLMWo7tttAiPSy9tiB7pC9BZri0qzpHQcmLaztg2I3t1L2mkv8PhORTc_2f41
    Og9rCUnGxeBrF8JKF4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvddtkedgtdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepvffujghfhfffkfggtgesthdtredttddttdenucfhrhhomhepffgrvhhiugcu
    gfgumhhonhgushhonhcuoegumhgvsegumhgvrdhorhhgqeenucggtffrrghtthgvrhhnpe
    fhkeeguedtvdegffffteehjedvjeeitefgfefgffdugeffffegudehgeetgeelkeenucfk
    phepkedurddukeejrddviedrvdefkeenucevlhhushhtvghrufhiiigvpedtnecurfgrrh
    grmhepmhgrihhlfhhrohhmpegumhgvsegumhgvrdhorhhg
X-ME-Proxy: <xmx:yeR_YGjUOYneNd857rU3RbhyZZQS5gZ6Iq7WM1USmOzwSQOvdGY-2A>
    <xmx:yeR_YG9MOKfU4q86Qb8OXV2pYVPdIU3U_TejcXCb6euiikeAGsp0sw>
    <xmx:yeR_YJsJPLyQMKhPEKfMeHztgJuPz9MY9rSznjfTUjMt3PD0srNRYA>
    <xmx:yeR_YBJUNYIaud5Cc8g3k8dTKqDtl0d5AlWQlglg2iGsH3BXrXJMjA>
Received: from disaster-area.hh.sledj.net (disaster-area.hh.sledj.net [81.187.26.238])
        by mail.messagingengine.com (Postfix) with ESMTPA id C075B108005B;
        Wed, 21 Apr 2021 04:39:36 -0400 (EDT)
Received: from localhost (disaster-area.hh.sledj.net [local])
        by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id 297b95e4;
        Wed, 21 Apr 2021 08:39:35 +0000 (UTC)
To:     Sean Christopherson <seanjc@google.com>,
        Aaron Lewis <aaronlewis@google.com>
Cc:     jmattson@google.com, kvm@vger.kernel.org
Subject: Re: [PATCH 1/2] kvm: x86: Allow userspace to handle emulation errors
In-Reply-To: <YH8eyGMC3A9+CKTo@google.com>
References: <20210416131820.2566571-1-aaronlewis@google.com>
 <YH8eyGMC3A9+CKTo@google.com>
X-HGTTG: heart-of-gold
From:   David Edmondson <dme@dme.org>
Date:   Wed, 21 Apr 2021 09:39:35 +0100
Message-ID: <m2sg3kt4jc.fsf@dme.org>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tuesday, 2021-04-20 at 18:34:48 UTC, Sean Christopherson wrote:

> On Fri, Apr 16, 2021, Aaron Lewis wrote:
>> +			KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES;
>> +		vcpu->run->emulation_failure.insn_size = insn_size;
>> +		memcpy(vcpu->run->emulation_failure.insn_bytes,
>> +		       ctxt->fetch.data, sizeof(ctxt->fetch.data));
>
> Doesn't truly matter, but I think it's less confusing to copy over insn_size
> bytes.

And zero out the rest?

dme.
-- 
Woke up in my clothes again this morning, don't know exactly where I am.
