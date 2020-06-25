Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9105820A59E
	for <lists+kvm@lfdr.de>; Thu, 25 Jun 2020 21:18:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406119AbgFYTSq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Jun 2020 15:18:46 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:20568 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2403948AbgFYTSq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 25 Jun 2020 15:18:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593112724;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1u2YKBzrXcn4fzjo4kHGu+dt+WpWy189+dhEfAKQ46A=;
        b=hPh+yfUGCoeKVaAtJoxOtyeh5afOawFDaEfXuSiJyZWjxjW/Cz58IOTZea48dnujSuyu4Z
        cMpFgIJD6Pb4CyN8of2fvJocXpba6ckgYUdqACM3q65EI466DvKYEnHYb9VSJRwuVACT34
        rOo2yBW37EjsPZm+x+Rc8dHBXZW6vPI=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-206-aMcBvVZLO7y4089QgsdzqA-1; Thu, 25 Jun 2020 15:18:43 -0400
X-MC-Unique: aMcBvVZLO7y4089QgsdzqA-1
Received: by mail-wr1-f71.google.com with SMTP id o12so7804694wrj.23
        for <kvm@vger.kernel.org>; Thu, 25 Jun 2020 12:18:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1u2YKBzrXcn4fzjo4kHGu+dt+WpWy189+dhEfAKQ46A=;
        b=VS0/phdndGOiZVDLaB2TNwzDtPJrPcS+sA++HCyJO2va8kxv5lZ7ouy0eiy0386ysf
         Tz6kbpOgJA3zPaRuEfeWoUCjiqGMHdTUGqj4PxVfLby4WOz+1GtwbHktZtOzSI06Db26
         TwN2yU5Sne6WNTa338Eics1LXtLiMDsY7ZjHgfNGyhfTmNvIWjfbUZEG9PZ/Zfy+wfqy
         wiALkyASX416ad8CfTe2jMMDCWm4b8IlIZVB6CpqxpOmjH3D7gyiTsztQmJLEIh+m3Ep
         pIlMWWd8FqK03pV+6hFiBfkROUatY9RPwA4PG+ePRjHAkTgR7k/XgR3BruaECx5blaFw
         phWg==
X-Gm-Message-State: AOAM532aREq6lc6hKAk0RVc2v3Q83D5qTSWguIX0odyMTiVT11X6XVV5
        12zWSpX2UfCcbA/FQ1DVlW0lh90hQgIGKLqzyLcvMYmvA9qFa8CeGgwcHR/EUnoMKrWvIvRNrjs
        tKX4s7/bQPsDu
X-Received: by 2002:a1c:dfd6:: with SMTP id w205mr5343531wmg.118.1593112722063;
        Thu, 25 Jun 2020 12:18:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyleAt06tb1iQLTRXzJnM6rc4YuDsdK/F6LXOuyBvmly8v7PaVXMdMziqodLGb95e4JDowPcA==
X-Received: by 2002:a1c:dfd6:: with SMTP id w205mr5343516wmg.118.1593112721869;
        Thu, 25 Jun 2020 12:18:41 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:91d0:a5f0:9f34:4d80? ([2001:b07:6468:f312:91d0:a5f0:9f34:4d80])
        by smtp.gmail.com with ESMTPSA id k14sm9702277wrn.76.2020.06.25.12.18.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jun 2020 12:18:41 -0700 (PDT)
Subject: Re: [PATCH kvm-unit-tests] x86: move IDT away from address 0
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     kvm <kvm@vger.kernel.org>, mcondotta@redhat.com,
        Thomas Huth <thuth@redhat.com>
References: <20200624165455.19266-1-pbonzini@redhat.com>
 <8926010E-3AC0-4707-B1E2-A8DF576660F9@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <ded0805e-15a4-5af8-0edd-10f9c9cf57d7@redhat.com>
Date:   Thu, 25 Jun 2020 21:18:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <8926010E-3AC0-4707-B1E2-A8DF576660F9@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/06/20 20:59, Nadav Amit wrote:
> I think that there is a hidden assumption about the IDT location in
> realmode’s test_int(), which this would break:
> 
> static void test_int(void)
> {
>         init_inregs(NULL);
> 
>         boot_idt[11] = 0x1000; /* Store a pointer to address 0x1000 in IDT entry 0x11 */
>         *(u8 *)(0x1000) = 0xcf; /* 0x1000 contains an IRET instruction */
> 
>         MK_INSN(int11, "int $0x11\n\t");
> 
>         exec_in_big_real_mode(&insn_int11);
>         report("int 1", 0, 1);
> }

Uuuuuuuuuuuuuuuumph... you're right. :(  Will send a patch tomorrow.

Paolo

