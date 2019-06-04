Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2798C34E9F
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2019 19:21:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbfFDRVt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jun 2019 13:21:49 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:46336 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbfFDRVt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jun 2019 13:21:49 -0400
Received: by mail-wr1-f67.google.com with SMTP id n4so11429155wrw.13
        for <kvm@vger.kernel.org>; Tue, 04 Jun 2019 10:21:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aZCqktS52AJM8iTkAxC0HXOtipNJipNMkyC5KaLcOao=;
        b=fLAQ4EpVlwh9JCuC4wj8eByjg+/MvZ/Xdmq3E6eH5+nTZnJT6ylcLBa4FlgiYoutxW
         e+hCi2MgrDY1177FgbXLdg+oO7s/QlNiQjwLnThe9K7oUhqNBMGwLwGOd0nnbbHQe3ob
         4D/CckRtKTJI6xJXX/Bq2WR6Xdj7v+c8pwxWBI8DtbNusRVlLGhZiuiKHEK+wxX9x/or
         9YlQdkFtG6Sf1iDGgtuoAncVq3SH8XLBViYQGU5Mw2KQ/cNgDgHcWd4PWhe0oR6c4z7z
         D0QCKI75jAbmXbXwgFZj1BOsKmbX8CXsr5ub8VZHYj/H9f7rRzkTovHB6CwC0fSqhmBd
         X21w==
X-Gm-Message-State: APjAAAULi8VinB501326cDM0a+nU3QYCwFxjwGnnRDXZzNCo5aEKhWJS
        TC/vtnvPGY9ghiSpMyclsxGi5Q==
X-Google-Smtp-Source: APXvYqysXFmEUqK56lL+EkDr76SL2ye2+BKDa4abnzlnJr3o0mf2ks5Vljt4Tstr2j3qpHXknNL5ng==
X-Received: by 2002:adf:e34e:: with SMTP id n14mr2006796wrj.169.1559668907797;
        Tue, 04 Jun 2019 10:21:47 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:657f:501:149f:5617? ([2001:b07:6468:f312:657f:501:149f:5617])
        by smtp.gmail.com with ESMTPSA id h21sm15648512wmb.47.2019.06.04.10.21.47
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Jun 2019 10:21:47 -0700 (PDT)
Subject: Re: [PATCH] Fix apic dangling pointer in vcpu
To:     Saar Amar <Saar.Amar@microsoft.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc:     "rkrcmar@redhat.com" <rkrcmar@redhat.com>
References: <VI1PR83MB0317F837797D43F91B90149BF11B0@VI1PR83MB0317.EURPRD83.prod.outlook.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f4cf2f7b-1752-849d-4e99-1ce6b336c1b0@redhat.com>
Date:   Tue, 4 Jun 2019 19:21:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <VI1PR83MB0317F837797D43F91B90149BF11B0@VI1PR83MB0317.EURPRD83.prod.outlook.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/06/19 11:23, Saar Amar wrote:
> Hey guys, can you please help me getting this patch in?
> 
> Attached both as file, and here is the plaintext. Thanks a lot!

Please reply to this email with your "Signed-off-by: Saar Amar
<Saar.Amar@microsoft.com>" to indicate acceptance of the "Developer's
Certificate of Ownership", then I will include it. Thanks!

Paolo
