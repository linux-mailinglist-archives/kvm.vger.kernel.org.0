Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23DB337A44
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 18:55:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729708AbfFFQz1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 12:55:27 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:40272 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725267AbfFFQz1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jun 2019 12:55:27 -0400
Received: by mail-wm1-f67.google.com with SMTP id v19so661527wmj.5
        for <kvm@vger.kernel.org>; Thu, 06 Jun 2019 09:55:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=e0PF/PRB4Dx464JI+62Sjm5BGxJ6iTtAjp+eMvS+9bQ=;
        b=dsk+rXzg7GQwKpwimksbdu/aks4KBgnG5Y9+kikQvYdYnVxL9zHeM95wK7QdOJLYgL
         GIyY5K9YN80bdSC2gGb1lBhV1pQIpi7B7ktmXwGxrYYD7BzVII5N+a8PnjQMecF4Shyo
         ybOYl5gMLWI/CZHUrS7FLiffJAJ6R590rz2x78+Mfv2/GkTWb8BWO4GKyWXxVSkTQYrR
         N0foMkhgI9+XzN/dNF5AgZC9jlAWTMjcXN/rtZy/xOrBMEcLMx365UwyvSZoddJlSuXs
         eDN702PB0lY3pggHw5LS9sUMdRwgTOjInJJfCJeikPzsUCsKTIR1A0Sa8ZDS+bUrfmTh
         tEWg==
X-Gm-Message-State: APjAAAWZMnW3U7TRA39Kxi/qgslehbdFDe+vuHhnGKmqQXoQQCynDrQm
        euONBJwCGe9S4rhPIqcmZhb2e12Ec8A=
X-Google-Smtp-Source: APXvYqx17U2BiF5bdxdi6bsUURFJpu50wB/d/uSqHOSv/VWExJkYhQ5Hv2Lc2ZbAXhPcHvk5p0/P1A==
X-Received: by 2002:a1c:c305:: with SMTP id t5mr637660wmf.163.1559840125304;
        Thu, 06 Jun 2019 09:55:25 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:657f:501:149f:5617? ([2001:b07:6468:f312:657f:501:149f:5617])
        by smtp.gmail.com with ESMTPSA id n19sm2214953wmk.6.2019.06.06.09.55.24
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Jun 2019 09:55:24 -0700 (PDT)
Subject: Re: [PATCH 01/13] KVM: nVMX: Use adjusted pin controls for vmcs02
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     kvm@vger.kernel.org
References: <20190507191805.9932-1-sean.j.christopherson@intel.com>
 <20190507191805.9932-2-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <fc222b2f-33d8-529b-143e-d27d9f8293d4@redhat.com>
Date:   Thu, 6 Jun 2019 18:55:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190507191805.9932-2-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/05/19 21:17, Sean Christopherson wrote:
> KVM provides a module parameter to allow disabling virtual NMI support
> to simplify testing (hardware *without* virtual NMI support is virtually
> non-existent, pun intended).  

I wish. :)  The reason for that module parameter is to test the path
because removing it got many complaints...

Paolo
