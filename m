Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BED1D1C2B
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2019 00:49:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732041AbfJIWtI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Oct 2019 18:49:08 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:23932 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731158AbfJIWtI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Oct 2019 18:49:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1570661346;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=smo/1DMoDi6BoPO3VhnXBmaalnnl0+/1gK5zg3BJ8bk=;
        b=ASXTyJP6FBoCBEAF/RmE28RqU9DD9gBTUFBMJpg9K/o8e0ou8yURP3Sazxk2kjT2lhWkMr
        jfwpq1D4VZOAQ4ZiwSCJikyYm7Zc4rCKmwtv8yZs1/qhk/huuWPUIXJ/msn3YAPDnDafF8
        GJuBI4oMtJZiK+Eb1hB7XJ837DcCbUY=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-308-p7vUYzfmPGKQNhyzHPk1Rg-1; Wed, 09 Oct 2019 18:49:05 -0400
Received: by mail-wr1-f69.google.com with SMTP id n18so1766107wro.11
        for <kvm@vger.kernel.org>; Wed, 09 Oct 2019 15:49:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pl/sOdIseXbSMs8CYTi6wU9klAJAOqH4PkfR/1ctNCQ=;
        b=izifnKcSPch/ohFNvqVelc2VCidFS3qwSN+1i7ThqhV/x0//z8dt8w6E4corJV1Vmz
         yLsfREDmUTwIQJoPVeMl0+2EwVnBwNf+OKWpfBGUGzVS+lXqdHxlI9BQCV/aTVFSVdaS
         RbLxVQ2AxJzC/njXNbWfOLQXDdgBmF61WFgoMN2i0JKpGUI+c2A9KKERmKh4pnbPnFm/
         syEtHMo+UUoEi87AvoC6SOaZrRXQFS9r4dEUx7iloyp1Yf5zTNRCna2KktFQAt+UK0vf
         EdrYZyNCCJn7xR4yWWwjszDwVSgroqDeFUTz4LxfbebNJyswyPpGTjvuEtMoTtX3Vycz
         KcXA==
X-Gm-Message-State: APjAAAUE0FU6kIjvGD4FzpBsFHFjGpEAS14k5AfJkgEErfFeLttE2vX/
        ugS6nToW8i8WYR/9LqzVqdFv6e/xHmbRH3D06rdaq8MuuT6WRzrmT3Yc3HawovHWVS8u0UN+aI0
        wEhtb8B0DKtcE
X-Received: by 2002:adf:f607:: with SMTP id t7mr5240822wrp.114.1570661344141;
        Wed, 09 Oct 2019 15:49:04 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwBKdr9YMbKjm49OPMmw17P/ScYuQKwXUNdYhGZR2BhNCLZOaB52Ay7Hp1cMwYBD3uCUbxBmw==
X-Received: by 2002:adf:f607:: with SMTP id t7mr5240801wrp.114.1570661343890;
        Wed, 09 Oct 2019 15:49:03 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id a7sm5697825wra.43.2019.10.09.15.49.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Oct 2019 15:49:03 -0700 (PDT)
Subject: Re: [Patch 3/6] kvm: svm: Add support for XSAVES on AMD
To:     Jim Mattson <jmattson@google.com>
Cc:     Aaron Lewis <aaronlewis@google.com>,
        Babu Moger <Babu.Moger@amd.com>,
        Yang Weijiang <weijiang.yang@intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        kvm list <kvm@vger.kernel.org>,
        Luwei Kang <luwei.kang@intel.com>
References: <20191009004142.225377-1-aaronlewis@google.com>
 <20191009004142.225377-3-aaronlewis@google.com>
 <56cf7ca1-d488-fc6e-1c20-b477dd855d84@redhat.com>
 <CALMp9eRNdLdb7zR=wwx2tTc8n-ewCKuhrw9pxXGVQVUBjNpRow@mail.gmail.com>
 <9335c3c7-e2dd-cb2d-454a-c41143c94b63@redhat.com>
 <CALMp9eTW56TDny5MehuW-wS8dHWwfVEdzEvZQkOfVumEwcMWAA@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <85d601ec-9f69-6c71-0839-b9291f540efb@redhat.com>
Date:   Thu, 10 Oct 2019 00:49:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eTW56TDny5MehuW-wS8dHWwfVEdzEvZQkOfVumEwcMWAA@mail.gmail.com>
Content-Language: en-US
X-MC-Unique: p7vUYzfmPGKQNhyzHPk1Rg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/10/19 23:58, Jim Mattson wrote:
> I was just confused by your wording;
> it sounded like you were saying that KVM supported bit 8.
>=20
> How about:
>=20
> /*
>  * We do support PT if kvm_x86_ops->pt_supported(), but we do not
>  * support IA32_XSS[bit 8]. Guests will have to use WRMSR rather than
>  * XSAVES/XRSTORS to save/restore PT MSRs.
>  */

Good!

Paolo

