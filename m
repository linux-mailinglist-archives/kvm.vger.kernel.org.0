Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CA9D373CC
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 14:08:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726972AbfFFMIW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 08:08:22 -0400
Received: from mail-wm1-f48.google.com ([209.85.128.48]:53193 "EHLO
        mail-wm1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726581AbfFFMIW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jun 2019 08:08:22 -0400
Received: by mail-wm1-f48.google.com with SMTP id s3so2178501wms.2
        for <kvm@vger.kernel.org>; Thu, 06 Jun 2019 05:08:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=I8RvB6jddbZPnktx+ihdHDDrH0fjfgh05ZRWWC2JtyI=;
        b=PoYmU9xyZ4vXim5li/joXSLtUG6UV+XoCKv4eaDvMSmKJ8NkKRiFruW2TbnFYl6M4j
         6AN7qiPP1sfeyXRGppmadqnFAsgzHB32iXDEALiZipl/Mr50XVE+s4ZmB82PtaOKfxLR
         tPN2oyJxoSF1/8oGUgH7Yr9YgVYtFFK/th9U9h52OLJC5Oi2m7DYTpnZCfv5a+agw1Ou
         XohDC8xJwOBumEAqNMIMzeS3eyFdUZNiBA/mQ5SkksMnMRcY0bQa6EJQeFPURLqFR7an
         A0mCJVb7gGdIKupFG3sRufpE11TNsKG9xWWc1mlQNNJ6aKMpohjEtVJwHdxBs1YqQU6T
         FASg==
X-Gm-Message-State: APjAAAWhOIpKPp1X2XNxGkRwFUj5Y0VjiBZ2LjqX3Ej8dnQ/mY6oR0HX
        V/LNd252RFjP69dlI2oxUCXWWg==
X-Google-Smtp-Source: APXvYqxeQslgkTH+Cchm3M4OmTfKHWFX7M1+Js2xnKmzCoU9G4+u/5MrDHy24BlUkEGTd1oBe9Z3Bg==
X-Received: by 2002:a1c:2082:: with SMTP id g124mr25401930wmg.71.1559822901045;
        Thu, 06 Jun 2019 05:08:21 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:657f:501:149f:5617? ([2001:b07:6468:f312:657f:501:149f:5617])
        by smtp.gmail.com with ESMTPSA id t13sm3126953wra.81.2019.06.06.05.08.20
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Jun 2019 05:08:20 -0700 (PDT)
Subject: Re: [kvm-unit-tests PULL 0/2] Ppc next patches
To:     Laurent Vivier <lvivier@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org
Cc:     kvm-ppc@vger.kernel.org, Thomas Huth <thuth@redhat.com>
References: <20190517130305.32123-1-lvivier@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <587f9377-dda6-48c1-b520-4c2350b6a581@redhat.com>
Date:   Thu, 6 Jun 2019 14:08:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190517130305.32123-1-lvivier@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/05/19 15:03, Laurent Vivier wrote:
>   https://github.com/vivier/kvm-unit-tests.git tags/ppc-next-pull-request

Pulled, thanks.

Paolo
