Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9822331754
	for <lists+kvm@lfdr.de>; Sat,  1 Jun 2019 00:48:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbfEaWsy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 May 2019 18:48:54 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:40525 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726450AbfEaWsy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 May 2019 18:48:54 -0400
Received: by mail-wr1-f66.google.com with SMTP id p11so2633587wre.7
        for <kvm@vger.kernel.org>; Fri, 31 May 2019 15:48:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=y9k13cZ+n1F6x5AEsA+RnO5Mipc/lwIYcLLJMJTNRxo=;
        b=IG1oP+WEkL9XC9KP6MbQjRhW+NY7fLoSctYUAOaT6NHhrYdtu0Qz2akIJ0Zc4KbqYV
         MnPDZmK0Hlf/tziKAaPWJdhdW/mD5C9RLg+5mRPrqpAteoi7x8mUZzhG6jKoatoKoZY6
         cKXzyAe8pahgtW21bAmaW45oa+CyQOIp33SuXoH8gGZ3OZ3hx/RgGvAIza0Pfy8pWEkH
         H8TGArwsNClKXYmG/j8JDEMmeOyXjevuOLdOGV7TaHrAAH/5IY1Ew5/bdjw+6CwpOhWo
         YjDBFMAsGNhkE6qKQdJUF2A7N2Z2DGA+tthBrdd5punvoXayNXdN/hO+jzoS71tLDGkW
         bdIA==
X-Gm-Message-State: APjAAAUfqy76qMGJKSJfnumoWYfJxcYHkOQ7tEg3xbP4tibUXFhhQ/Xu
        VrQGn+G+HpyGBksyw8ZG39M26Q==
X-Google-Smtp-Source: APXvYqwFMYrk4a9W99J/XVFz2YbGajHhR641S875JRrlRgfZVtVkqVJI7PCFZaOv0Yd4X34GHJ2aOA==
X-Received: by 2002:adf:ff88:: with SMTP id j8mr8269035wrr.317.1559342932549;
        Fri, 31 May 2019 15:48:52 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:f910:d845:2bcd:e6c8? ([2001:b07:6468:f312:f910:d845:2bcd:e6c8])
        by smtp.gmail.com with ESMTPSA id r16sm6458879wmh.17.2019.05.31.15.48.51
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 May 2019 15:48:51 -0700 (PDT)
Subject: Re: [GIT PULL] Please pull my kvm-ppc-fixes-5.2-1 tag
To:     Paul Mackerras <paulus@ozlabs.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org
Cc:     kvm-ppc@vger.kernel.org
References: <20190530115944.GA6675@blackberry>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <bdda6df3-f130-7ac7-6eb9-9c8ccff11bdc@redhat.com>
Date:   Sat, 1 Jun 2019 00:48:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190530115944.GA6675@blackberry>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/05/19 13:59, Paul Mackerras wrote:
>   git://git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc tags/kvm-ppc-fixes-5.2-1

Pulled, thanks.

Paolo
