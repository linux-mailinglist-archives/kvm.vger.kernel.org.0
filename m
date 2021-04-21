Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 682DE3670FB
	for <lists+kvm@lfdr.de>; Wed, 21 Apr 2021 19:10:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242773AbhDURL0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 13:11:26 -0400
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:38057 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242747AbhDURLV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 21 Apr 2021 13:11:21 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id A709D1940FC1;
        Wed, 21 Apr 2021 13:10:44 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 21 Apr 2021 13:10:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=tEL1KB
        UOWLdIutLcYeoODFn8sW0g2GSP9e5rB5nWXfg=; b=VbKQeWihdnLPNdynDTVBbA
        mQikQhN+azuilj1XHD6Sv1wQcQgYlvK675+Vaoi3r6JLfBeWWrcF8S4y2WBokw8+
        dXUS0MjGdKtA5rAbd355EgHaJDHwzEKmKba2TjcxuGNw3eJO81W9VfwtesgXAqZ8
        0vbzpq1DDVXtvE9bgo1lv10+ZHljMp4x+wDTZgz3F5oLSUwIgH8cNzf8p9MI063R
        MZWTSL8r+4Y4UQiWAkAFpa54tyE0Z1PhObvDGZiSqQ9FHPebqo+s2O/j85qD/bi+
        GQ22kIOS56X0CmTj8GcM7nxLTRJQeU/0SqbakeMREutCXMpozlUJ7+WO1I16ZGTQ
        ==
X-ME-Sender: <xms:lFyAYD8lYwvmhJYdxkFZXTB6BjMGEwlCVwpJa6DrDx4qaSzgqMQSCg>
    <xme:lFyAYPuRtyxNf7iPDpca3XVXCg5JXq137IcLZWFwBfUhE0p2j_41I3LQVIXWBuJ85
    -j8GFO2_cZZhBzFDRg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvddtkedgudduudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefvufgjfhfhfffkgggtsehttdfotddttddtnecuhfhrohhmpeffrghvihgu
    ucfgughmohhnughsohhnuceoughmvgesughmvgdrohhrgheqnecuggftrfgrthhtvghrnh
    epkeetteegteevlefggeehieekueeuheegteejffefgeelvdfggffgleevuefhkeeunecu
    ffhomhgrihhnpehslhgvughjrdhnvghtnecukfhppeekuddrudekjedrvdeirddvfeekne
    cuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepughmvges
    ughmvgdrohhrgh
X-ME-Proxy: <xmx:lFyAYBACFSz9SsDfu5glb7yhuSt1cewIXEPu_X6p_V4gjpex26cYdw>
    <xmx:lFyAYPesb7BusupSMkBlbPah_Setbxs6eL0eVuYw4e6oK4utYb2TEw>
    <xmx:lFyAYINT6lYtoTB3ZfF1X6KuZ3IBWegH9CcHRvrSG0iKv1Gr3cUmHA>
    <xmx:lFyAYNpsC4N8PzHjQvq36vLtSIZkjViCZ94pCR8_Riss_uthwgBSHg>
Received: from disaster-area.hh.sledj.net (disaster-area.hh.sledj.net [81.187.26.238])
        by mail.messagingengine.com (Postfix) with ESMTPA id C10ED24005B;
        Wed, 21 Apr 2021 13:10:43 -0400 (EDT)
Received: from localhost (disaster-area.hh.sledj.net [local])
        by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id 26527a9e;
        Wed, 21 Apr 2021 17:10:42 +0000 (UTC)
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        kvm list <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] kvm: x86: Allow userspace to handle emulation
 errors
In-Reply-To: <CAAAPnDH1LtRDLCjxdd8hdqABSu9JfLyxN1G0Nu1COoVbHn1MLw@mail.gmail.com>
References: <20210421122833.3881993-1-aaronlewis@google.com>
 <cunsg3jg2ga.fsf@dme.org>
 <CAAAPnDH1LtRDLCjxdd8hdqABSu9JfLyxN1G0Nu1COoVbHn1MLw@mail.gmail.com>
X-HGTTG: zarquon
From:   David Edmondson <dme@dme.org>
Date:   Wed, 21 Apr 2021 18:10:42 +0100
Message-ID: <cunmttrftrh.fsf@dme.org>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wednesday, 2021-04-21 at 09:24:13 -07, Aaron Lewis wrote:

>> > +     if (insn_size) {
>> > +             run->emulation_failure.ndata = 3;
>> > +             run->emulation_failure.flags |=
>> > +                     KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES;
>> > +             run->emulation_failure.insn_size = insn_size;
>> > +             memcpy(run->emulation_failure.insn_bytes,
>> > +                    ctxt->fetch.data, sizeof(ctxt->fetch.data));
>>
>> We're relying on the fact that insn_bytes is at least as large as
>> fetch.data, which is fine, but worth an assertion?
>>
>> "Leaking" irrelevant bytes here also seems bad, but I can't immediately
>> see a problem as a result.
>>
>
> I don't think this is a problem because the instruction bytes stream
> has irrelevant bytes in it anyway.  In the test attached I verify that
> it receives an flds instruction in userspace that was emulated in the
> guest.  In the stream that comes through insn_size is set to 15 and
> the instruction is only 2 bytes long, so the stream has irrelevant
> bytes in it as far as this instruction is concerned.

As an experiment I added[1] reporting of the exit reason using flag 2. On
emulation failure (without the instruction bytes flag enabled), one run
of QEMU reported:

> KVM internal error. Suberror: 1
> extra data[0]: 2
> extra data[1]: 4
> extra data[2]: 0
> extra data[3]: 31
> emulation failure

data[1] and data[2] are not indicated as valid, but it seems unfortunate
that I got (not really random) garbage there.

Admittedly, with only your patches applied ndata will never skip past
any bytes, as there is only one flag. As soon as I add another, is it my
job to zero out those unused bytes? Maybe we should be clearing all of
the payload at the top of prepare_emulation_failure_exit().

Footnotes:
[1]  https://disaster-area.hh.sledj.net/tmp/dme-581090/

dme.
-- 
Music has magic, it's good clear syncopation.
