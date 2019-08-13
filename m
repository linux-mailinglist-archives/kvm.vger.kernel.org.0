Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD6BF8B97E
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2019 15:07:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728919AbfHMNHF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Aug 2019 09:07:05 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:41925 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728359AbfHMNHF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Aug 2019 09:07:05 -0400
Received: by mail-qk1-f196.google.com with SMTP id g17so8865156qkk.8;
        Tue, 13 Aug 2019 06:07:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=u2xvKIFDx1GL5oTSP01MeCVOPBZI+ggPw3/ysWgy6nQ=;
        b=AMQCAmjVMkny/5BGWEJOty2vX6MCoQOq1G95l9/RhyYwDeuU1PMYleA2bWX5YliVyH
         rOauuQZa/wbMZf2yl6pD0hCEWri5sJtc3UjkvirA0NdQZoRA6c8M94xWGChvU/JmHNqt
         AMVDQAKeV8OOie/K4ms5uDBSsivZB7M+hlK/9skh8vbJJCO6V0a2vgY7cn8oEYUNeubg
         1Lg52jf2CO154nU8/4GHcAoz8DThCz1yU76rM2x+akAQjE8TesDkXLiCRVGfZ4bXEgyW
         kpOXbQ9xTc0dlYdPf2yGSqH43dJ5sNs6pDt3QOF8N/DPjsWSmy+59G0ej6J3mPFa6WAd
         P8vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:reply-to
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=u2xvKIFDx1GL5oTSP01MeCVOPBZI+ggPw3/ysWgy6nQ=;
        b=J/0rPUQRWvFXnfzCc+YSoxt016YnAEtZAoHutTgMaYzGVJShF9kVWgLa5Ks8cLXjjD
         C+or4lPP/LMp7Jg33jn/IDMhOiid02aXWsdPa7vmhZA3BUwX6Nalby3w8Rm/yGIpb1eL
         A9H/vWM2huvRY22SRUN7bkqptYnMNCHzTaWqg71/F6C9LW4ZXpqGTrf8e2/09n679TT9
         cqDebtDO4wT/ACVO9+TJrL/AOvGNv8FjBwZAZdbuyx6Zc+aXFWKjPj4TThHicHLu2HRw
         pHRFKtEHUOhuykudsGi8HRtt8+FSktFWVD5tBxeZDld9ndLYCmS9NidosRWVl04hyEUG
         tOFw==
X-Gm-Message-State: APjAAAXVySD/hJNQnH4AfRteSKqOyCa3RmBOfHYR+pbF2Xqxe/ocasx/
        LCBJaqngp2VeU9nt6cMvaOc=
X-Google-Smtp-Source: APXvYqwQcmk/rYDeQGfkSovcy7x1HElxEfyMb+XjS4Vy1redRSZJ+8OA4u4px8DqFuh6ELZ0M4OLzg==
X-Received: by 2002:a05:620a:12d2:: with SMTP id e18mr33667320qkl.176.1565701623607;
        Tue, 13 Aug 2019 06:07:03 -0700 (PDT)
Received: from localhost (tripoint.kitware.com. [66.194.253.20])
        by smtp.gmail.com with ESMTPSA id f7sm2448257qtj.16.2019.08.13.06.07.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Aug 2019 06:07:03 -0700 (PDT)
Date:   Tue, 13 Aug 2019 09:07:02 -0400
From:   Ben Boeckel <mathstuf@gmail.com>
To:     Alison Schofield <alison.schofield@intel.com>
Cc:     "Kirill A. Shutemov" <kirill@shutemov.name>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>,
        David Howells <dhowells@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Kai Huang <kai.huang@linux.intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>, linux-mm@kvack.org,
        kvm@vger.kernel.org, keyrings@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCHv2 57/59] x86/mktme: Document the MKTME Key Service API
Message-ID: <20190813130702.GC9079@rotor.kitware.com>
Reply-To: mathstuf@gmail.com
References: <20190731150813.26289-1-kirill.shutemov@linux.intel.com>
 <20190731150813.26289-58-kirill.shutemov@linux.intel.com>
 <20190805115837.GB31656@rotor>
 <20190805204453.GB7592@alison-desk.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190805204453.GB7592@alison-desk.jf.intel.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 05, 2019 at 13:44:53 -0700, Alison Schofield wrote:
> Yes. Fixed up as follows:
> 
> 	Add a "no-encrypt' type key::
> 
>         char \*options_NOENCRYPT = "type=no-encrypt";
> 
>         key = add_key("mktme", "name", options_NOENCRYPT,
>                       strlen(options_NOENCRYPT), KEY_SPEC_THREAD_KEYRING);

Thanks. Looks good to me.

Reviewed-by: Ben Boeckel <mathstuf@gmail.com>

--Ben
