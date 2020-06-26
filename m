Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF5FB20AD65
	for <lists+kvm@lfdr.de>; Fri, 26 Jun 2020 09:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728811AbgFZHin (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Jun 2020 03:38:43 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:56196 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726128AbgFZHim (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Jun 2020 03:38:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593157121;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s0r92vpPNUuJ5d0ss49/zV+F8au5GdLIRCKpG3jKSAA=;
        b=D53ZeFUry77IIpGEIEILS6EbBbDFym+Qn4E2xcapNMnCeT3ZkQL0Kn9C27s59MwDep1nDa
        JJtsGlxB3pukgwwXfL9QEYZpQ+9jeDsrmW09GJnyVTWJ7bkkr1Hov+Ncbrw60Dj2FLCkiV
        HB7EPVyrhdcpbZ4/Z20+IJFbOl4DC6M=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-473-94bjQjhjOnqyE4lt_DlcFQ-1; Fri, 26 Jun 2020 03:38:39 -0400
X-MC-Unique: 94bjQjhjOnqyE4lt_DlcFQ-1
Received: by mail-wr1-f70.google.com with SMTP id p10so9995607wrn.19
        for <kvm@vger.kernel.org>; Fri, 26 Jun 2020 00:38:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=s0r92vpPNUuJ5d0ss49/zV+F8au5GdLIRCKpG3jKSAA=;
        b=T9WuUtvOjxhMD6Mq7yXFeh9KJDkaUxWA6lgzsemRcTa1PGDw7emYHI0y5A4XY5JLVh
         Xl/TdhdK1LInhzNyHvdf7RvblNym2RxkHKzqUpSGLSphdzl7rczw0qZCF55a/2OcRjWc
         BRgLU8AT2f+CpnFcXQ0AaU0Ume/cRV10hDEhFoY+4AqiW81OQUt8UzKVx9inGZDRil0s
         tkWPKesiVhYWMFAQpjWdHzIhEQLNVd1xr4Dh88dRn8hMcFHChYEfvyzWQ3hT0+c8c1Ny
         27VkRdUjyhf2EgpZjb2sFvvQsKf5JP9Y+mPoEdB9QPn5cFFxmOM91TgKaTXU+Lrqn06D
         ulqg==
X-Gm-Message-State: AOAM533Jpem2cFwMVyMe2mkHlZS75Y+1vDyojBFZp1IvwyqbMkvubbwy
        dkSIMzydDnBcHBSg6KwMfOMa0ZawBwU6R1NtLbt7NCVRS4HDNtvy0Yl0rBfq5f05zxJDZ7n8alt
        DqWfnQPGuSyfU
X-Received: by 2002:a1c:e209:: with SMTP id z9mr1976603wmg.153.1593157118049;
        Fri, 26 Jun 2020 00:38:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwXc1SO408Hl23Nzc/21/+jA8Rn/l+R/j3FpV4K6qTif0B9i/uhH+LvKKpNaV8umOIp4TGiig==
X-Received: by 2002:a1c:e209:: with SMTP id z9mr1976576wmg.153.1593157117777;
        Fri, 26 Jun 2020 00:38:37 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:91d0:a5f0:9f34:4d80? ([2001:b07:6468:f312:91d0:a5f0:9f34:4d80])
        by smtp.gmail.com with ESMTPSA id h29sm38085551wrc.78.2020.06.26.00.38.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Jun 2020 00:38:37 -0700 (PDT)
Subject: Re: [PATCH kvm-unit-tests] x86: move IDT away from address 0
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     kvm <kvm@vger.kernel.org>, mcondotta@redhat.com,
        Thomas Huth <thuth@redhat.com>
References: <20200624165455.19266-1-pbonzini@redhat.com>
 <8926010E-3AC0-4707-B1E2-A8DF576660F9@gmail.com>
 <ded0805e-15a4-5af8-0edd-10f9c9cf57d7@redhat.com>
 <1b981258-6b03-a120-622f-8e597570ed53@redhat.com>
 <F270BE77-F66B-42CC-B6BE-D4D3272B9F17@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <6dd03c38-9689-84c4-04ab-aaa79bbadd6a@redhat.com>
Date:   Fri, 26 Jun 2020 09:38:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <F270BE77-F66B-42CC-B6BE-D4D3272B9F17@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/06/20 09:06, Nadav Amit wrote:
>> Actually the IDTR is not reloaded by exec_in_big_real_mode, so this
>> (while a bit weird) works fine.
> Err… So it means I need to debug why it does not work for *me*…

Hmm, maybe a dislike for an IDT that is placed above the first MiB of
memory?  But I cannot read anything about it in the manuals.

In any case I would accept a patch that switches to the "usual" address
0 IDT in exec_big_real_mode.

Paolo

