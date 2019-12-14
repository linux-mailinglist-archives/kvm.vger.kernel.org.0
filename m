Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0482811F39F
	for <lists+kvm@lfdr.de>; Sat, 14 Dec 2019 20:16:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbfLNTF3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 14 Dec 2019 14:05:29 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:44041 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726358AbfLNTF2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 14 Dec 2019 14:05:28 -0500
Received: by mail-pj1-f65.google.com with SMTP id w5so1158985pjh.11
        for <kvm@vger.kernel.org>; Sat, 14 Dec 2019 11:05:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=L6Ag2VBHQuyYKlLF6xopn+ObtOOk20kt2kwMNta1TZ4=;
        b=dBfPnvea4ivJLjWYoK0YZTJZ6ymafU2UOw/hMu72wx68w1+8PJYUMOtHC993pd0xEU
         twB04Qf1uW+LDDosnn3vQMVPL+PYHn/zzw7y/EaJhcQHy+kZUwJu8eUi1KxrrFInnkJJ
         JXdOylA2CLz0gxeQ28lGedcAuexitrMZuj0+S2KtsCj+eyKgkVyEP0FF4qSdOkuBhdf7
         nX7DKKUDs6hwTtM4mUVAixzCwDBMhMQejnHpgUVGzXA1lcKjo4fctGp67cxz2wRyF9ru
         61u+RgZM5ohRGZnemQarrFh6kLXQfxq2uDmwJeCecEdzNG8L6rTddy4BFV07xjRiiw4m
         wjuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=L6Ag2VBHQuyYKlLF6xopn+ObtOOk20kt2kwMNta1TZ4=;
        b=M8X/jT0VuF71q0OBYxIY++HZtv8qtEkUMDHEsBkzj4MUo5ogfdKAxRhaRV3i79IKcM
         gCnE63e4kI+TfMu+Ga3W9uYwVVi6KXdRZI30IuWOzVcC7OFqoxyY7bOAkU/QUsZ45WSI
         zUjxC9VuIDt8U07aq375PWaVaEhPFTk64VZQjnjfBfA4sDYORoHxQWSfPCk/+aH2MhzN
         y4WZU7s7jgKlCFunVh5O50pXS9oLhvRcr7WRjIV8ve3UiBXCLnA70SWK77T48EqiCxL9
         eg4mz9H02FSq546uElghkvL1FsG0KtYWdpo8pjGkhV44ARnQ3iQEz8+oNVavTuWuweB9
         XRkg==
X-Gm-Message-State: APjAAAU3H4+mRwFQa47jUboOVLPwGyoZGKalrhFon5qr7NTbbAG1W/DL
        vPJkL4vzkY49QJZspLeqSLOMKw==
X-Google-Smtp-Source: APXvYqzxuHjwdPrNa4nj3JStR1j9VmsiCOfNY/yVNIel4uPhFiwULXaMO5uqnw3bTrEcaP2mIzW4oQ==
X-Received: by 2002:a17:90a:3243:: with SMTP id k61mr6885687pjb.55.1576350327883;
        Sat, 14 Dec 2019 11:05:27 -0800 (PST)
Received: from google.com ([2620:15c:2ce:0:9efe:9f1:9267:2b27])
        by smtp.gmail.com with ESMTPSA id d23sm15906004pfo.176.2019.12.14.11.05.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Dec 2019 11:05:27 -0800 (PST)
Date:   Sat, 14 Dec 2019 11:05:23 -0800
From:   Fangrui Song <maskray@google.com>
To:     Peter Shier <pshier@google.com>
Cc:     kvm@vger.kernel.org, drjones@redhat.com,
        Marc Orr <marcorr@google.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH kvm-unit-tests] Update AMD instructions to conform to
 LLVM assembler
Message-ID: <20191214190523.pinshqv2fdbmuotg@google.com>
References: <20190220202442.145494-1-pshier@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190220202442.145494-1-pshier@google.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> I am applying it, but I'm seriously puzzled by the clgi one.  Can you
> open a bug on LLVM?
> 
> Paolo

The clgi change does not appear to be needed.

- "clgi \n\t"
+ "clgi;\n\t"

clang 7.0.0, 8.0.0 (downloaded from releases.llvm.org) and HEAD (built from source) compile
"clgi" fine.

% ~/ccls/build/clang+llvm-7.0.0-x86_64-linux-gnu-ubuntu-16.04/bin/clang -mno-red-zone -mno-sse -mno-sse2 -m64 -O1 -g -MMD -MF x86/.emulator.d -Wall -Wwrite-strings -Wempty-body -Wuninitialized -Wignored-qualifiers -fno-omit-frame-pointer -fno-pic -Woverride-init -Wmissing-prototypes -Wstrict-prototypes -std=gnu99 -ffreestanding -I /tmp/p/kvm-unit-tests/lib -I /tmp/p/kvm-unit-tests/lib/x86 -I lib -c -o x86/svm.o x86/svm.c -w
# succeeded
