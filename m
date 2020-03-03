Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25A671774BA
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 11:58:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727970AbgCCK6c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Mar 2020 05:58:32 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:44457 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727440AbgCCK6b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Mar 2020 05:58:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583233110;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/zXPTBF4JWqoYp8eI1kQcfpbOmowjFDH+kFOoB5ZRAY=;
        b=addizytcWTRvn/X9T23mvbOoiXm+733LKAUJYOWmc3P2fhE2OUrlH2ubMslZX6vfyVZ2vg
        VzaIO0XglbotySysilKs9fI7w3t1+AnwgWem/eA1WP17R4Hrrllkqz0BAEsGMdImQwqh6j
        IZgluHd2PoN0bJDaRVJpgowv3z0TmqQ=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-203-nKb8N8m7Odu3PT4Geb4j_g-1; Tue, 03 Mar 2020 05:58:29 -0500
X-MC-Unique: nKb8N8m7Odu3PT4Geb4j_g-1
Received: by mail-wr1-f69.google.com with SMTP id o9so1043998wrw.14
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2020 02:58:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/zXPTBF4JWqoYp8eI1kQcfpbOmowjFDH+kFOoB5ZRAY=;
        b=jzAKUfJLVTRiTeN0+v+RRa6JPqdwwBkxMBmGyMnvnPup2mSZf3IgUcJ6SMHtzgbED6
         GXc0KgohfwwCdweFgLSEKYegnZGSu5kuqhuOC6/CIas7V+Q3rnjWgaU1hnDrCWcswn3k
         305X7CGZqinZRIuCxFE9OTrYREM2fca2hreeh/Z58ceVRSq2917QfLEHSisGE2Uq2YwA
         xYwWmv4Eq+N7tRRQ0LVx6Rb1Yf6J437wq+NSCMHXzC5FzEH0nnSRb4hhzzc1kYBhSXpd
         gQ4aZR+UCJjYuM+YulpKEy62LXVx503CbZhZl83CJ1MjEc2IGEExn8YyCOkDY1SrAeRF
         ooLA==
X-Gm-Message-State: ANhLgQ2l+Ffo/Z1ScHW03RaT0cXCu36LH2+YQwin4MLiZ9dM+ygIQhMc
        pRK54otfXU+by3foK0Glk7O1Al1n6skNbCY0HIAWldAR0y60FpUVSUj6kdEjAlrv++/UewMbujQ
        4hJCXU4gINanO
X-Received: by 2002:a05:600c:104d:: with SMTP id 13mr3750723wmx.50.1583233107988;
        Tue, 03 Mar 2020 02:58:27 -0800 (PST)
X-Google-Smtp-Source: ADFU+vsd4BS7rp91JqsVP0DXSUT94e+JAinRKnGWMQ7Cvy39iLCGgQ+L61XcKLOC/AXfzKHmLi4C1w==
X-Received: by 2002:a05:600c:104d:: with SMTP id 13mr3750709wmx.50.1583233107679;
        Tue, 03 Mar 2020 02:58:27 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:9def:34a0:b68d:9993? ([2001:b07:6468:f312:9def:34a0:b68d:9993])
        by smtp.gmail.com with ESMTPSA id e7sm13496617wrt.70.2020.03.03.02.58.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Mar 2020 02:58:27 -0800 (PST)
Subject: Re: [GIT PULL] KVM changes for Linux 5.6-rc4
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Oliver Upton <oupton@google.com>
References: <1582570669-45822-1-git-send-email-pbonzini@redhat.com>
 <87zhcyfvmk.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8fbeb3c2-9627-bf41-d798-bafba22073e3@redhat.com>
Date:   Tue, 3 Mar 2020 11:58:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <87zhcyfvmk.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/03/20 19:40, Vitaly Kuznetsov wrote:
> 
>  qemu-system-x86-23579 [005] 22018.775584: kvm_exit:             reason EPT_VIOLATION rip 0xfffff802987d6169 info 181 0
>  qemu-system-x86-23579 [005] 22018.775584: kvm_nested_vmexit:    rip fffff802987d6169 reason EPT_VIOLATION info1 181 info2 0 int_info 0 int_info_err 0
>  qemu-system-x86-23579 [005] 22018.775585: kvm_page_fault:       address febd0000 error_code 181
>  qemu-system-x86-23579 [005] 22018.775592: kvm_emulate_insn:     0:fffff802987d6169: f3 a5
>  qemu-system-x86-23579 [005] 22018.775593: kvm_emulate_insn:     0:fffff802987d6169: f3 a5 FAIL
>  qemu-system-x86-23579 [005] 22018.775596: kvm_inj_exception:    #UD (0x0)
> 
> We probably need to re-enable instruction emulation for something...

This is a rep movsw instruction, it shouldn't be intercepted.  I think
we have a stale ctxt->intercept because the

        /* Fields above regs are cleared together. */

comment is not true anymore since

    commit c44b4c6ab80eef3a9c52c7b3f0c632942e6489aa
    Author: Bandan Das <bsd@redhat.com>
    Date:   Wed Apr 16 12:46:12 2014 -0400

    KVM: emulate: clean up initializations in init_decode_cache

    A lot of initializations are unnecessary as they get set to
    appropriate values before actually being used. Optimize
    placement of fields in x86_emulate_ctxt

    Signed-off-by: Bandan Das <bsd@redhat.com>
    Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Paolo

