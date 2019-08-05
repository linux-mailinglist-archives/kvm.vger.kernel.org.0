Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71B05818A4
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2019 13:58:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728781AbfHEL6l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Aug 2019 07:58:41 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:45992 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728513AbfHEL6j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Aug 2019 07:58:39 -0400
Received: by mail-qk1-f196.google.com with SMTP id s22so59866556qkj.12;
        Mon, 05 Aug 2019 04:58:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=e8LeZYKHIbk2Da0fZqUR7a7Js8ma4FkwyhW8sZVdCZk=;
        b=hngqHboWeegeHkoet35hMfGDZ/a/9CNOIPPlA7NKG//W57AWG953gR+21a8vIOnq2N
         O0gY/5V/Q5CZoeXcwKWhnYHZmHPjIPfgIkS1CCntV3/YU320muttIZpPr7T73dzyk1eh
         J8mE0rX4SOvyBpv2kyOrHfn251KwfVS42gfdsBq2ouwztwzMpiiUaEfyj5TeLH2fWGkN
         5HoRjM9ml34Tua73Y6ycsRF6u7bIqTtdkUcIwAlHJz9fMvtiARFg4/EEIVv3xGLVOxGl
         iVEyymREv3wB5kUc6CKPmRZoQQTpjQFt0L224wAgcxG3zATbmMyqyyyJRnhyA7k7657N
         T2EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:reply-to
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=e8LeZYKHIbk2Da0fZqUR7a7Js8ma4FkwyhW8sZVdCZk=;
        b=uXjnn4IiVe+iUNP5vHI3r8WNR1Su5qVKbU13/jLTMxrd2Ax3qukIREE1fgS0PEoxeD
         0FKGDGpu81vIc0AphomoMZAkxZwfEu6jH0U8pH6QbypzKD/yutfglBtiEoJnihzmuqqg
         cvcR1umJIKVnLXtaySjjCFF53DWxnzUoEJul/S7AiSCROR1pHNWYEEakyV7C2oKOWQbv
         ZyHyNfXXh5vv/gYH6w5qoeifI1ZxZ1UqdQkN9bk0hAp7NCduWF2wD2CA4XuwSLxf3COt
         Qmo1tQ3wjxoAkg/obWm7IutxdEE+tKujNoTLAqUyVmawjmoXRjSon48U7/2AY7YywmD/
         +66Q==
X-Gm-Message-State: APjAAAXSwGdcu3sKcWAMNXhYMo6tCxykn4KoKpwv40KeIMZS0Zj5Meik
        IoJ7CcFcBRgwup6a6q20vQ6+DHRUp5c=
X-Google-Smtp-Source: APXvYqyryDXftcMnqgW+D3kNypxJP/bHopPpzdZ1j1jlioL4L8ry7VpPYRyN6eeewLRhsKtQysUWHw==
X-Received: by 2002:a05:620a:15a5:: with SMTP id f5mr100840063qkk.45.1565006317755;
        Mon, 05 Aug 2019 04:58:37 -0700 (PDT)
Received: from localhost (tripoint.kitware.com. [66.194.253.20])
        by smtp.gmail.com with ESMTPSA id o10sm40861276qti.62.2019.08.05.04.58.37
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 05 Aug 2019 04:58:37 -0700 (PDT)
Date:   Mon, 5 Aug 2019 07:58:37 -0400
From:   Ben Boeckel <mathstuf@gmail.com>
To:     "Kirill A. Shutemov" <kirill@shutemov.name>
Cc:     Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>,
        David Howells <dhowells@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Kai Huang <kai.huang@linux.intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Alison Schofield <alison.schofield@intel.com>,
        linux-mm@kvack.org, kvm@vger.kernel.org, keyrings@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCHv2 57/59] x86/mktme: Document the MKTME Key Service API
Message-ID: <20190805115837.GB31656@rotor>
Reply-To: mathstuf@gmail.com
References: <20190731150813.26289-1-kirill.shutemov@linux.intel.com>
 <20190731150813.26289-58-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190731150813.26289-58-kirill.shutemov@linux.intel.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 31, 2019 at 18:08:11 +0300, Kirill A. Shutemov wrote:
> +	key = add_key("mktme", "name", "no-encrypt", strlen(options_CPU),
> +		      KEY_SPEC_THREAD_KEYRING);

Should this be `type=no-encrypt` here? Also, seems like copy/paste from
the `type=cpu` case for the `strlen` call.

--Ben
