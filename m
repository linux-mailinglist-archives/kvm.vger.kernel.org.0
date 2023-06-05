Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FFEB7227DA
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 15:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233888AbjFENu6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 09:50:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231744AbjFENu5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 09:50:57 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EED09C;
        Mon,  5 Jun 2023 06:50:56 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1685973055;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aOOaZVN3ubREzDpZuhbvM0jDgWHp0JpWQOfwHpZT/R8=;
        b=goDPa9cTC+calZUkYhuLz3/KLCNTG1QylH1MVcaCowaJ56mROJsJmEdZ93voyC4eYXx1U8
        VrCCSyLHYVpwTkxHyDPwYNjbfKgHMZLsQP9C8EhhipShH+Gx2LJ/breeynxFoXF2B67IWG
        0NONBS2aNa9F7xQgaqYdvMbuIMD9lYDeQNY8qYurhopPuos2kbikhSPNf4ImWsNPnN4Rf9
        Vn9gMQ/Ie8j9dkMaxgg07qz4AeHqvLQ9G8PQUhUThd/arD2a7PD6rs60FuNn7kLYMNFJ0X
        yFC8ezxHbDWsgqPIEhsndNjapl/nG8d3u+nfqwFFtPxUTncXTNJk43q1iBpgrA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1685973055;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aOOaZVN3ubREzDpZuhbvM0jDgWHp0JpWQOfwHpZT/R8=;
        b=zqPDsEQ/eGdhDwPAXIBfcs06igqGlZ9wTKgpyRNMyB+8y6fTATiiW3o3py78KlWugIRZBq
        TBZZVse12n9megDg==
To:     Xin Li <xin3.li@intel.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, kvm@vger.kernel.org
Cc:     mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, peterz@infradead.org, andrew.cooper3@citrix.com,
        seanjc@google.com, pbonzini@redhat.com, ravi.v.shankar@intel.com,
        jiangshanlai@gmail.com, shan.kang@intel.com
Subject: Re: [PATCH v8 26/33] x86/fred: allow single-step trap and NMI when
 starting a new thread
In-Reply-To: <20230410081438.1750-27-xin3.li@intel.com>
References: <20230410081438.1750-1-xin3.li@intel.com>
 <20230410081438.1750-27-xin3.li@intel.com>
Date:   Mon, 05 Jun 2023 15:50:55 +0200
Message-ID: <877csi6mrk.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 10 2023 at 01:14, Xin Li wrote:
> Allow single-step trap and NMI when starting a new thread, thus once
> the new thread returns to ring3, single-step trap and NMI are both
> enabled immediately.
>
> High-order 48 bits above the lowest 16 bit CS are discarded by the
> legacy IRET instruction, thus can be set unconditionally, even when
> FRED is not enabled.

I assume this has been validated to be true on _all_ CPU incarnations of
_all_ x86 vendors.

If so, then please document it. If not, then go back to the drawing
board.

Thanks,

        tglx

