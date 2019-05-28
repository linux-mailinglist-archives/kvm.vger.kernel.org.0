Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C9742C48B
	for <lists+kvm@lfdr.de>; Tue, 28 May 2019 12:38:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726512AbfE1Kh7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 May 2019 06:37:59 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:50775 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726305AbfE1Kh7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 May 2019 06:37:59 -0400
Received: by mail-wm1-f67.google.com with SMTP id f204so2333034wme.0
        for <kvm@vger.kernel.org>; Tue, 28 May 2019 03:37:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=N+L8dJuY36DL8X88QkYAfhAhxVvOb7H/x9f4R/7rstw=;
        b=oVFm5+TQPBtyl4EP2Ol9fQ45qbWNAuQXeev+wIr3ezC1BUBha716a8jFZLH8nEOZh9
         cuI5r6Kn6RJdB1bWanwh7OOyq8TpuAJVBwj1FMKUYZd7+jqt88B5Jgrq5nTlwumwayh8
         cYI9jI7BeYeT85oFsi7wd8dBsWTxPE8X7vvZYE11l40lNgJVViiAep9TqzbaAkuNIUDh
         GSW3gJ2E7A0xLnIQXGZEmLyEJYyr6gHYTYEAIe+wwCi5f88zYEx/57vMRXrLtmjeGTUz
         YdYVx6KtUwEb+MocT9L8Lps2BE6cToWU5HM02JMXGYIK9I8QYcO+Gj63EPHhykut5ZYR
         oNwg==
X-Gm-Message-State: APjAAAUcIe0Of2x7EkfcBY0RdyGZ4ZGYnMdGKDm4SGYlw7TRL6A/PEBh
        LC50uzy3OdOYbOX1qYOKDS47eg==
X-Google-Smtp-Source: APXvYqwu4YiKztrl6zKyR0+N9/4IIk0xyRgAMs4l+ssyNpNqxvDJl8M9+5Olco5IWR6MaDR3bYndLQ==
X-Received: by 2002:a7b:c842:: with SMTP id c2mr2668611wml.28.1559039877186;
        Tue, 28 May 2019 03:37:57 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id n7sm2742811wrw.64.2019.05.28.03.37.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 May 2019 03:37:56 -0700 (PDT)
Subject: Re: [PATCH] kvm: add kvm cap values to debugfs
To:     Suraj Jitindar Singh <sjitindarsingh@gmail.com>,
        kvm@vger.kernel.org
Cc:     rkrcmar@redhat.com, paulus@ozlabs.org, dja@axtens.net
References: <20190528083535.27643-1-sjitindarsingh@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8f6429ac-f6a5-bf24-59c5-a101b75bfd40@redhat.com>
Date:   Tue, 28 May 2019 12:35:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190528083535.27643-1-sjitindarsingh@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/05/19 10:35, Suraj Jitindar Singh wrote:
> KVM capabilities are used to communicate the availability of certain
> capabilities to userspace.
> 
> It might be nice to know these values without having to add debug
> printing to the userspace tool consuming this data.

Why not write a separate script that prints the capability values?

Paolo
