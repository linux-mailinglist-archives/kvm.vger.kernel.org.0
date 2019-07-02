Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A87F15D452
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2019 18:35:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726308AbfGBQfY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Jul 2019 12:35:24 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44081 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725996AbfGBQfY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Jul 2019 12:35:24 -0400
Received: by mail-wr1-f65.google.com with SMTP id e3so9049581wrs.11
        for <kvm@vger.kernel.org>; Tue, 02 Jul 2019 09:35:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=enIA+h24t+EEfNWKmxUgDgvLU7KKOtBimqc9ImIS0FQ=;
        b=MERLkzTWeZM00WBygTRkhyGw98SNX25nHd25MeHD0t0tdZ2vsYncZWlr7vqR7Cch7j
         VQimaPA+Fm8ciIBQy2W73EDHZ8e05n23/dtL6R4kKt36xamb5jAe9RvVJGUoGw0TEby4
         o4z44DdJLzTZXs1H6GFmujPmsLH8wJcIbi3FQ0EtSU1HXmduR4gpW1dnOYgZSJQWySCo
         6EgM4GXg5fG1BPrrmjYeDn2GDryVFmodlQ9t1fKebRT2BwLsV9DRD2gnGd27pM1Q6TPw
         aRJ7c8HxveW2rFIPlxOZ3drEhqP/D9VZMM+30FtHwFS7FGUqTrfQ9vgpbpkvZ6VTWzKe
         sMdw==
X-Gm-Message-State: APjAAAXnOXlRtAbUuEBLGrurUSnLL1prKiRyVopC7iE3LiVwXo151HS6
        iucEOLVeHuOuf3On+U1YbgJqE2yFnTc=
X-Google-Smtp-Source: APXvYqyzuHQzWRzALAZ0yA6WwdSb/QSpOmdir1S7oqwmvC7w+P+3gan2FhiNbOet7fq1VGYfTTJ3OQ==
X-Received: by 2002:a5d:6389:: with SMTP id p9mr25903667wru.297.1562085322163;
        Tue, 02 Jul 2019 09:35:22 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:b8:794:183e:9e2a? ([2001:b07:6468:f312:b8:794:183e:9e2a])
        by smtp.gmail.com with ESMTPSA id b8sm2948459wmh.46.2019.07.02.09.35.21
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Jul 2019 09:35:21 -0700 (PDT)
Subject: Re: [PATCH 2/2] KVM: nVMX: trace nested VM-Enter failures detected by
 H/W
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Jim Mattson <jmattson@google.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm list <kvm@vger.kernel.org>
References: <20190308231645.25402-1-sean.j.christopherson@intel.com>
 <20190308231645.25402-3-sean.j.christopherson@intel.com>
 <CALMp9eQ4ADEqTmL4-1wT9Xh9mT9Xof9nmFypqF7_-TeKkHdOMQ@mail.gmail.com>
 <20190314184540.GC4245@linux.intel.com>
 <fe728261-67dc-a247-3ed3-b403269ac83d@redhat.com>
 <CALMp9eQFT2qEuuOoZRpRkx0Fr0452kTnGyxKjK8qP9skWtY0rA@mail.gmail.com>
 <0cb40615-de9e-4c3e-bcc7-68300a09481d@redhat.com>
 <20190619194718.GH1203@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b5c94774-4d67-6268-0aed-1af66686cd98@redhat.com>
Date:   Tue, 2 Jul 2019 18:35:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190619194718.GH1203@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/06/19 21:47, Sean Christopherson wrote:
> are you waiting on me for something? :-D

Can you please rebase the patches?

Thanks,

Paolo
