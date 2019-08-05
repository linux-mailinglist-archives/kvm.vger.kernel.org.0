Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FFCB820B8
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2019 17:49:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728056AbfHEPtO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Aug 2019 11:49:14 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:36967 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726559AbfHEPtN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Aug 2019 11:49:13 -0400
Received: by mail-wr1-f67.google.com with SMTP id n9so59838382wrr.4
        for <kvm@vger.kernel.org>; Mon, 05 Aug 2019 08:49:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=965zgdxTpawv/xodHdjHPNchDoxDHf/nNEvAYnHyeaw=;
        b=s5tQxLfcui0HkulzyhxKTsKxeK3+Tr7k5999EY3umG3XLDVYTcLjMv2N97BbWUBxbo
         sQenhuKJBSZCOvXm/0t4jxl0sxYukSMa22neihiiAeV2jQdkk+8gdor8Yncizf873I/n
         8V9/OC8tOuYmC8J5hTxkm33XQ85exPTou14RgTOug2r5id6x9QnJ38Yxu8uOYD0FCqU4
         J4t3+PVqVHZ1i2Vo+pZdQt9CEclsitcVCVdPEOTybRM+DSb7Eg+1EPOz684ht239Swwq
         rO89x1ZDnpbWQbxnME5DCknUWpMoC6w4Ib1VSm9a1hNsAc1Cu+ezQ5/xIcAvdtEUepbS
         TksQ==
X-Gm-Message-State: APjAAAVsgD4HlNW0zSIEiJ8iWZ0suzV/QlDoC2itBsr12tiuM2vFZQqX
        /WIJ0v4c9WnA1vdDtM9V3asJtA==
X-Google-Smtp-Source: APXvYqxpq/VRwNb4eDeKTNIzh3vUSyhUSzrlzOhdyS9uCibJCszxrfR7GChMrB2IKLQN4flVLQ8TEQ==
X-Received: by 2002:a5d:4e90:: with SMTP id e16mr23939395wru.339.1565020151874;
        Mon, 05 Aug 2019 08:49:11 -0700 (PDT)
Received: from [192.168.178.40] ([151.21.165.91])
        by smtp.gmail.com with ESMTPSA id n8sm71962097wro.89.2019.08.05.08.49.11
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Aug 2019 08:49:11 -0700 (PDT)
Subject: Re: [PATCH v2 1/2] KVM: remove kvm_arch_has_vcpu_debugfs()
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Radim Krm <rkrcmar@redhat.com>, kvm@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
References: <20190731185556.GA703@kroah.com>
 <6ddc98b6-67d9-1ea4-77d8-dcaf0b5a94cc@redhat.com>
 <alpine.DEB.2.21.1908030939530.4029@nanos.tec.linutronix.de>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <cd8e8df4-7d12-f111-04fd-fa4d5cb0d89b@redhat.com>
Date:   Mon, 5 Aug 2019 17:49:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.21.1908030939530.4029@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/08/19 09:41, Thomas Gleixner wrote:
> On Sat, 3 Aug 2019, Paolo Bonzini wrote:
>> On 31/07/19 20:55, Greg KH wrote:
>>> There is no need for this function as all arches have to implement
>>> kvm_arch_create_vcpu_debugfs() no matter what, so just remove this call
>>> as it is pointless.
>>
>> Let's remove kvm_arch_arch_create_vcpu_debugfs too for non-x86 arches.
> 
> Can't we remove _all_ that virt muck? That would solve a lot more problems
> in one go.

It sure would take some maintainer burden off me. :)

Paolo
