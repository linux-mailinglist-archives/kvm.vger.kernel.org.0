Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 290144A744
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2019 18:44:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729846AbfFRQoA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jun 2019 12:44:00 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:53254 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729319AbfFRQoA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jun 2019 12:44:00 -0400
Received: by mail-wm1-f65.google.com with SMTP id x15so4055654wmj.3
        for <kvm@vger.kernel.org>; Tue, 18 Jun 2019 09:43:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=U9zxtkoZwhnJFFCX0A2D5Wx51sna0MNIsF7wCnvQr8Y=;
        b=HfUh6xB9308nC4VAUQaKriaI/WwU1TZ+eamhWyMhDJ42+8NZvFfBM3QAoU57uOlx47
         i+CFbLFOq+XlQbtUgxtyleYY7m2q5nwWGC7CIzfaIPrfrp6E6fRaJIOC/v/DWb/LNK7m
         rsWXAs4maXM/IOchSo5vHJV5dYr0K9SdKhV8n7suG5F4+vsm1lksXmslmynxym/7SMTW
         EuTVMQJtshZLsZJ9KoTjKfy0CJRJxJPc7SVbnXIxgJg9wU0cFJ1rEGdY4mKYgN5izWgh
         vfH365Tniyp0PDyHw3cRLGkDKZIvfnpl1eyKqJJ2VLmcGRhjA8pCoBtkU/SIXrWePUJ5
         yyew==
X-Gm-Message-State: APjAAAVXC4uGKqVl6DFvFGXJhmq0Fy6qZmkfThiH7XlvU7N2CFFC/zhA
        Jpks6tnycgGDhaN/SYNrOXyfZg==
X-Google-Smtp-Source: APXvYqxqaxwx9AsD8KRHoKJayou8ibFDWOOap67b06dvF+r+xR0glc/5phevjwrXe35EFPEpcGPm3g==
X-Received: by 2002:a7b:cc16:: with SMTP id f22mr4769563wmh.115.1560876238594;
        Tue, 18 Jun 2019 09:43:58 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:51c0:d03f:68e:1f6d? ([2001:b07:6468:f312:51c0:d03f:68e:1f6d])
        by smtp.gmail.com with ESMTPSA id e7sm1944266wmd.0.2019.06.18.09.43.57
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Jun 2019 09:43:58 -0700 (PDT)
Subject: Re: [QEMU PATCH v3 6/9] vmstate: Add support for kernel integer types
To:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Liran Alon <liran.alon@oracle.com>
Cc:     qemu-devel@nongnu.org, mtosatti@redhat.com, rth@twiddle.net,
        ehabkost@redhat.com, kvm@vger.kernel.org, jmattson@google.com,
        maran.wilson@oracle.com,
        Nikita Leshenko <nikita.leshchenko@oracle.com>
References: <20190617175658.135869-1-liran.alon@oracle.com>
 <20190617175658.135869-7-liran.alon@oracle.com>
 <20190618085539.GB2850@work-vm>
 <AB34E76F-231C-4E66-B5CB-113AFCE7A20F@oracle.com>
 <20190618154218.GH2850@work-vm>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <5816685f-32f7-68dd-596c-7dcfaf7e3d4f@redhat.com>
Date:   Tue, 18 Jun 2019 18:44:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190618154218.GH2850@work-vm>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/06/19 17:42, Dr. David Alan Gilbert wrote:
>>> Have you checked that builds OK on a non-Linux system?
>> Hmm that’s a good point. No. :P
> Worth a check if you can find one lying around :-)

It does not, but it's a macro so it's enough to enclose the uses in
#ifdef CONFIG_LINUX or CONFIG_KVM.

Paolo
