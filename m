Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC393640C9
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2019 07:41:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbfGJFlQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jul 2019 01:41:16 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:32991 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725932AbfGJFlQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jul 2019 01:41:16 -0400
Received: by mail-ed1-f67.google.com with SMTP id i11so742415edq.0
        for <kvm@vger.kernel.org>; Tue, 09 Jul 2019 22:41:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OY11rmPpSH+D8B6VvScwEBe1DCnbT7zlyAqSZqOZeb0=;
        b=aVjTiCRydw5W5D3VVZ5a3RnkzEtF8FnM4NvvMSINx1++fYq8BY94J1G1SUDzXNCmya
         coAA3BzVRLjkkVbyKUn5zyLqBLDoIb/HtebS+CV8k3H9w9AFNIwZFj+Pl6lsqF8fHedL
         SceJrV1kf0BAnc9dfVayhYk2P/NhYOvVonwskcO8Ke0mrMiFlANnLSqQP/Wn4/aQIIHB
         2p6kNCMQ0DeEE/psFpwXOJReZNJ+1gtppBo83PT0uijt3liV3/fABUQc36aht10x7zsu
         r8FwNjViGL+mQ1tTsaU2Ybz6ert1+Z2HipZo3g3AmP6HhwnSKQP/oSrt+ia4EmzWO6Pt
         qLYw==
X-Gm-Message-State: APjAAAWiNbPHMjM3+M0N8DlSTjseF4a+MDV7uGzDy2p4q9+2xzzLFcsT
        vpPPVqbmu/ZQdzHj8uazdvgULA==
X-Google-Smtp-Source: APXvYqxF0wyLFpJaD+4S490iaEEB7HCOq+xZWNx1hKV86gZ/6GN/YPQ1vMZ1zyd7tQmKqhL2DF4Ixg==
X-Received: by 2002:a50:91e5:: with SMTP id h34mr28907927eda.72.1562737274869;
        Tue, 09 Jul 2019 22:41:14 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:19db:ad53:90ea:9423? ([2001:b07:6468:f312:19db:ad53:90ea:9423])
        by smtp.gmail.com with ESMTPSA id g11sm893689wru.24.2019.07.09.22.41.13
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 09 Jul 2019 22:41:14 -0700 (PDT)
Subject: Re: [PATCH v2 0/3] Documentation: virtual: convert .txt to .rst
To:     Luke Nowakowski-Krijger <lnowakow@eng.ucsd.edu>,
        linux-kernel-mentees@lists.linuxfoundation.org
Cc:     rkrcmar@redhat.com, corbet@lwn.net, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190709200721.16991-1-lnowakow@neg.ucsd.edu>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8b24581c-427f-847a-7f77-2b3fc5c5334e@redhat.com>
Date:   Wed, 10 Jul 2019 07:41:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190709200721.16991-1-lnowakow@neg.ucsd.edu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/07/19 22:07, Luke Nowakowski-Krijger wrote:
> After confirming with the appropriate lists that all the
> Documentation/virtual/* files are not obsolete I will continue
> converting the rest of the .txt files to .rst.

There is no obsolete information in Documentation/virtual/kvm.  Thanks
for this work!

Paolo
