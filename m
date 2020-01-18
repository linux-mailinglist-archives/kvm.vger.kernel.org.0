Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE8E41419E2
	for <lists+kvm@lfdr.de>; Sat, 18 Jan 2020 22:36:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727070AbgARVfW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 18 Jan 2020 16:35:22 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:48287 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726957AbgARVfV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 18 Jan 2020 16:35:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579383319;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s+aSiJdsJ4fdnsSQbUDUXR7vvH5ewWdg7+T/QPxjdZk=;
        b=SB+EwGtDwqphxytMF+SAwgoMuy40b1dAHu4QrR/2qk5cMPr7CkCahQoNBB0AM4lfhq8qKK
        FiaxvvHO5yNWIuZb+C4/JzLY63UspH4JbjM4WfSPILOmtaKMpKRQgA+KoAepWWYxma+S9o
        +IEhe+GX6P4dpi8MxFYY+7+XjhGJYcc=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-100-3ukhQSxiN_aY7j2ORO9b_w-1; Sat, 18 Jan 2020 16:35:18 -0500
X-MC-Unique: 3ukhQSxiN_aY7j2ORO9b_w-1
Received: by mail-wr1-f70.google.com with SMTP id f17so12164047wrt.19
        for <kvm@vger.kernel.org>; Sat, 18 Jan 2020 13:35:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=s+aSiJdsJ4fdnsSQbUDUXR7vvH5ewWdg7+T/QPxjdZk=;
        b=I4yWtVTQikBzC82+04jv85FbJW4s+vpzZBjcBWNVF/d75iTTLhFJS/h3ysEBG5VWWh
         MnDyDnI3SF3v+YxKk2AKMLbFHaQR+RRGAeg7+9wjovF/Kf/we0Uvin0HTNH8rS8VXTmS
         tOy1xKact5O9ZJZPzD8NDVnOlJ5wrI8WBIKEzc9mok0kKCdBAYHq+C56HP88Vuq4zZ+O
         z+DqZDeeMYdy9JNme0EUYOzhRUHCchsi/Lr1a863EZtsz0hEH1JAPAekIfmVs99NWgyZ
         XssA8LIsiiSYgqgXNP5YKF99hrSHEQ64QGDbpAtJTyCvvCADRUU20RxpudC0dUDg62tO
         1/xQ==
X-Gm-Message-State: APjAAAVG80/S+uJNkTXB+tHW0N0+5a2Mfzl43zCbAHae4FkN7t3rsQ/j
        OuuQqlN1mQKBbKyOcT+Y6cmk8ClvBW3xy/JblG/26++8p7dfUDPNVtfzLCpoTaU82Kf7v3yoNEH
        FkgYl4iRvAjFa
X-Received: by 2002:adf:a141:: with SMTP id r1mr9409749wrr.285.1579383317705;
        Sat, 18 Jan 2020 13:35:17 -0800 (PST)
X-Google-Smtp-Source: APXvYqwB7oJGW0eSsAQNqvqXydSLqwFZBqej1Tf+rmvEJmFTlg4HP0HzdzjgXqe4uuNENhJ80gwRbw==
X-Received: by 2002:adf:a141:: with SMTP id r1mr9409732wrr.285.1579383317489;
        Sat, 18 Jan 2020 13:35:17 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:e0d6:d2cd:810b:30a9? ([2001:b07:6468:f312:e0d6:d2cd:810b:30a9])
        by smtp.gmail.com with ESMTPSA id b21sm4835499wmd.37.2020.01.18.13.35.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Jan 2020 13:35:16 -0800 (PST)
Subject: Re: [PATCH v2 4/4] KVM: x86: Remove unused ctxt param from emulator's
 FPU accessors
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Derek Yerger <derek@djy.llc>,
        kernel@najdan.com, Thomas Lambertz <mail@thomaslambertz.de>,
        Rik van Riel <riel@surriel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Borislav Petkov <bp@suse.de>,
        Dave Hansen <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
References: <20200117193052.1339-1-sean.j.christopherson@intel.com>
 <20200117193052.1339-5-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b8491683-3717-4dbe-637f-c3daeef08d81@redhat.com>
Date:   Sat, 18 Jan 2020 22:35:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200117193052.1339-5-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/01/20 20:30, Sean Christopherson wrote:
> Remove an unused struct x86_emulate_ctxt * param from low level helpers
> used to access guest FPU state.  The unused param was left behind by
> commit 6ab0b9feb82a ("x86,kvm: remove KVM emulator get_fpu / put_fpu").
> 
> No functional change intended.

Makes sense since the new implementation of emulator_get/put_fpu can be
considered generic, and therefore it's okay not to tie it to ctxt->ops.

Queued, thanks.

Paolo

