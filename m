Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55A5A722DAF
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 19:32:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233930AbjFERcW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 13:32:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229825AbjFERcU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 13:32:20 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 080468F;
        Mon,  5 Jun 2023 10:32:20 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1685986338;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1CigOqIlz4ewWe8nj0xyMmaAiZJgw5HDSo0ZCDSHEfM=;
        b=mTCr5tkgfr73KLnphV9F5aHe08NKm/15/rTlWW+0+zpTcH6TCWwt4cKp4B27+lZZ5bGtbp
        P/XDT+BczlQBXAdsFeg/CKi0U7EtEVsxxGFPXysbmHeqF+qAeCWfyNpGaY376TlCrY1cVu
        2lzZNEjvxqyey5mRMYBGzL23aNsqXby5Netx6Jb3sods8KDWlyWhn3VrUWMyeoK+123zgv
        tjoilJZvZ/Zrg98xdrx7fUpHE+02uFOtjbRq/t/ouSWmpmosABHbUioJbdBfO/P3BwkJy+
        tlrey7PVuHR0VWxD5pstll+GlBaiofigmIVnfT72M75UulhHAcrMfRaNhg+46g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1685986338;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1CigOqIlz4ewWe8nj0xyMmaAiZJgw5HDSo0ZCDSHEfM=;
        b=zV3ilantK162hAxOmb5S+JIv10eF145NffpowWNXFvZCLvN2EKELhnmXf0fidYrmuWkdu4
        vKL1uI6IzwZ6kEAw==
To:     "H. Peter Anvin" <hpa@zytor.com>, Xin Li <xin3.li@intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        peterz@infradead.org, andrew.cooper3@citrix.com, seanjc@google.com,
        pbonzini@redhat.com, ravi.v.shankar@intel.com,
        jiangshanlai@gmail.com, shan.kang@intel.com
Subject: Re: [PATCH v8 00/33] x86: enable FRED for x86-64
In-Reply-To: <a87319a8-f87b-7bbb-697f-eb98b6ad4875@zytor.com>
References: <20230410081438.1750-1-xin3.li@intel.com>
 <a87319a8-f87b-7bbb-697f-eb98b6ad4875@zytor.com>
Date:   Mon, 05 Jun 2023 19:32:18 +0200
Message-ID: <87zg5d4xy5.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 05 2023 at 10:22, H. Peter Anvin wrote:
> So I feel obliged to throw in some defending of Xin here, mostly because=
=20
> in some of these cases I'm the perkeleen vittup=C3=A4=C3=A4[1] and not Xi=
n.

That's clear from the authorship and the style of the patches and not
all was criticism was directed at Xin obviously. He's just the messenger
in that case.

Thanks,

        tglx
