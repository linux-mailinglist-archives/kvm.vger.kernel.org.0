Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C15301B2816
	for <lists+kvm@lfdr.de>; Tue, 21 Apr 2020 15:37:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728597AbgDUNhL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Apr 2020 09:37:11 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:52092 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728391AbgDUNhK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Apr 2020 09:37:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587476229;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GYP1YDlNBMnycORNWlm6IFetMVB2wDT3m1YqxbCNVb0=;
        b=XYKzldiN0nEG0ZRC+uYiT+UJhtg5+3a3FzscuPfgByWSEnDGJZFRKNz9HSPzKQGnUuNycS
        lgPJCLnqLree/hI7OfrhpbhJRpyIQS7cCXRvowHhsxRd0m9SByURc6znfFZ2kWjylBarzU
        vCc1BpM9aSZpOv/evLTNQ/Wv8yrjol8=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-130-9rqpK5OZPjCBvbDdCQhWaA-1; Tue, 21 Apr 2020 09:37:07 -0400
X-MC-Unique: 9rqpK5OZPjCBvbDdCQhWaA-1
Received: by mail-wr1-f69.google.com with SMTP id a3so7506733wro.1
        for <kvm@vger.kernel.org>; Tue, 21 Apr 2020 06:37:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GYP1YDlNBMnycORNWlm6IFetMVB2wDT3m1YqxbCNVb0=;
        b=UQN418ahlZrhU2/zMYKxcL+DK5UrGtgUx62BJ5JcRnqA+pk0FIoB3u2jxf91m8KN9p
         Y+9EbG5Js2mIbTPqMMDXd9ueBGQuITsxGxp0MpZ9t2TJ+FNEQafEKFQD3KODG+1kt/zZ
         lZi/Aq62jYnDvrpwiFgw86PPO/SR+SSMDNvkl/mbyIosp3shMKLEG53M/wWulIUz1ADQ
         C0NK9/4joXp25MIQgvPpLdKuPNBreRIRa5e7hvbvcqPK3SHPv4wig6AU9/P2J53gecaQ
         5kKBGKiANTlL2bBOL8cip9rsFgpJ1aCrfKtBMQb7sW1rgXdvdaHk7OC8BPU1HV0SCxvo
         O3kg==
X-Gm-Message-State: AGi0PuZnetoFSNNFc9gk+g3U3RDx69jgYf+46+qo1ZJ/fG9rZH1ejxeq
        PetH7p4d8mU53RwuXOGjnxTFe9NJx/rQehLVcHpWF59XKIMEuyO/QNERlaBiItQbcak1KknryLM
        21B4R7OguJS8u
X-Received: by 2002:a7b:ce88:: with SMTP id q8mr5283276wmj.161.1587476226734;
        Tue, 21 Apr 2020 06:37:06 -0700 (PDT)
X-Google-Smtp-Source: APiQypKOBSIDEmyd50iLtny1lI00mt2RU6wtoVbdZptdvKB21AxBx8lJ3LHqNkiNwJOmAw7DTQ0CSQ==
X-Received: by 2002:a7b:ce88:: with SMTP id q8mr5283258wmj.161.1587476226531;
        Tue, 21 Apr 2020 06:37:06 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:f43b:97b2:4c89:7446? ([2001:b07:6468:f312:f43b:97b2:4c89:7446])
        by smtp.gmail.com with ESMTPSA id i17sm3688105wru.39.2020.04.21.06.37.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Apr 2020 06:37:06 -0700 (PDT)
Subject: Re: [GIT PULL] Please pull my kvm-ppc-fixes-5.7-1 tag
To:     Paul Mackerras <paulus@ozlabs.org>, kvm@vger.kernel.org
Cc:     kvm-ppc@vger.kernel.org, David Gibson <david@gibson.dropbear.id.au>
References: <20200420235300.GA7086@blackberry>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <365dfab9-9f9f-6c6a-7f4f-c5bbf7e67d41@redhat.com>
Date:   Tue, 21 Apr 2020 15:37:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200420235300.GA7086@blackberry>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/04/20 01:53, Paul Mackerras wrote:
>   git://git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc tags/kvm-ppc-fixes-5.7-1

Pulled, thanks.

Paolo

