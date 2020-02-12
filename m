Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9FD115A8CF
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2020 13:09:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727581AbgBLMJf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Feb 2020 07:09:35 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:24367 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727041AbgBLMJf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 12 Feb 2020 07:09:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581509374;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Xd/aWZzMFcT2m+1AWV4ND535kCy+Z0OTFOLbnwiLlgs=;
        b=daJWDZpxDKDoKJxcGZzIJc6Fs0Wao7rrLtQnFnEcPZxrHnPypxpUFcrTN4gU6DzE0zmqyZ
        eB/3BdYVrJsIIvBC4z+qUm0QjsPN9K0oPXEXqFwbMG/r+EyedUP5T58/cPW91SgUuZjb4g
        MkMMRAa9/hn8DX+/INpau5E8lN2Uxj8=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-202-rS47WDtqMBC0j8h0c-8TIg-1; Wed, 12 Feb 2020 07:09:32 -0500
X-MC-Unique: rS47WDtqMBC0j8h0c-8TIg-1
Received: by mail-wr1-f70.google.com with SMTP id v17so715715wrm.17
        for <kvm@vger.kernel.org>; Wed, 12 Feb 2020 04:09:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Xd/aWZzMFcT2m+1AWV4ND535kCy+Z0OTFOLbnwiLlgs=;
        b=L4vlF8snxc+UGl8p/FHZJGxU26s7v8NKOYHyWffJdFmqMsDI0UYvjXIcTerBMhCUF0
         xixycQPUSp+vpRshJC5tImRR7qK824CmP4VQDRI/BTfAbFOAgWBNv4wXg3J+BZL8Bj1g
         2DB6ezL3KJsBLWQQJxAiklWtt4saFULzaRIKn+NInee6641sHZOkDDUAHdfDLd9emduB
         wHFg5yU5rKtFYRuEvV6IaQKFeCn0cjegL44DMeb5lzvVnrj9p9bHZ4/CxMhoCW19ePJ0
         yhlBuyahKS3WDs8Vtifc4hDt1JUMAZcWynkxi3tA+v1ZKm75cfe5ALvRgN9DHZVXqzy8
         cJfg==
X-Gm-Message-State: APjAAAX59n6O+eFo8AuT8MrYPLKqsngZ3C6XywxVRy3qfCa8JcCo3OJ+
        RBURthMOa8l63JHCaXIyr4HPrj3VpJ8b/AfgJQ88qwqAJP1AaRbLLOoaZMo1ROH4+4nZPiOCV2C
        qa4utE/2qvVct
X-Received: by 2002:adf:fa50:: with SMTP id y16mr14208930wrr.183.1581509371261;
        Wed, 12 Feb 2020 04:09:31 -0800 (PST)
X-Google-Smtp-Source: APXvYqx6TYfL9d2yFQecMXw4gyRiHYC5y321fzdvM79+ALHl/QjW1BQHVMfN+wEmFYOAi7Yh7hfiRg==
X-Received: by 2002:adf:fa50:: with SMTP id y16mr14208902wrr.183.1581509370981;
        Wed, 12 Feb 2020 04:09:30 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:652c:29a6:517b:66d9? ([2001:b07:6468:f312:652c:29a6:517b:66d9])
        by smtp.gmail.com with ESMTPSA id a198sm501253wme.12.2020.02.12.04.09.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Feb 2020 04:09:29 -0800 (PST)
Subject: Re: [PATCH v5 0/4] selftests: KVM: AMD Nested SVM test infrastructure
To:     Eric Auger <eric.auger@redhat.com>, eric.auger.pro@gmail.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        vkuznets@redhat.com
Cc:     thuth@redhat.com, drjones@redhat.com, wei.huang2@amd.com,
        krish.sadhukhan@oracle.com
References: <20200207142715.6166-1-eric.auger@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <25441007-2b1a-f98a-3ca8-ffe9849d7031@redhat.com>
Date:   Wed, 12 Feb 2020 13:09:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200207142715.6166-1-eric.auger@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/02/20 15:27, Eric Auger wrote:
> 
> History:
> v4 -> v5:
> - Added "selftests: KVM: Remove unused x86_register enum"
> - reorder GPRs within gpr64_regs
> - removed vmcb_hva and save_area_hva from svm_test_data
> - remove the naming for vmcb_gpa in run_guest

I preferred v4. :)  I queued the patch to remove the unused enum though.

Paolo

