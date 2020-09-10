Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 021A7264100
	for <lists+kvm@lfdr.de>; Thu, 10 Sep 2020 11:11:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728936AbgIJJLi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Sep 2020 05:11:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40662 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726848AbgIJJL3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 10 Sep 2020 05:11:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599729088;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2S+dASRYX7B6gIlF4p7C2wh2Lfe0xE+w23SHE4uKPDk=;
        b=TIXXQNnt3q9+qWdGgzezLVDc0PBEqUoZQa2uCbKtvrO3pVewd7YqcIcZoZecVvrIHi6XbH
        fEL5oByU1NBW7y+l497ozAVshZepQLzwAspOyPmXI0LL9QrCpMvakQ49kj7nn9DajbwtYo
        sCcokMYUpVbG11rZ3csWWD5+IQlKBcQ=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-557-1Z3z--ByN9q94SmjFc9haw-1; Thu, 10 Sep 2020 05:11:26 -0400
X-MC-Unique: 1Z3z--ByN9q94SmjFc9haw-1
Received: by mail-ed1-f71.google.com with SMTP id x14so2158305edv.8
        for <kvm@vger.kernel.org>; Thu, 10 Sep 2020 02:11:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2S+dASRYX7B6gIlF4p7C2wh2Lfe0xE+w23SHE4uKPDk=;
        b=NLcFf+YX+kwRwAcTmStN7VOqOsCes3gfX8fHIe1tw+7zIYbVIFWzsbsjrr/EAKHsuy
         sCFf89Z+5bHmNUaVrAQag5omrnSeZNnOx+8P5AdKSE8Kv6F26cWiNR1hN0F/hBhwLiTg
         ucvnhctTaJv8NgxKhGmszKOp4prWkydiwu+z+nhnCfhF3BmO493l6ik2TnlCXUNKXVF7
         s8k4becmIEOLnrVCbpAOxi56rMsJeaI+sUHnso+eecHQ7gYi45skJegp33E0miS2daxe
         Zwscs5kYPt80lLwDuJDfGDLT4tr8fBNRPMzXzSAlYWu+SKZ4afkTxjSfThr5XyEzxNs/
         gDfg==
X-Gm-Message-State: AOAM533SoUmnQm3+UrrRfin61HpztHVc1nMe1OlNx2LnK3QBxIMynuuA
        rvLnZxUMa3WhUI6JsjCzLPHHFf3MSsrTolt/EYRvj5PGjPpB9xNp60WPw6f+32VdPTq3PfMEZ8y
        61dSVdbAeV2xr
X-Received: by 2002:a17:906:1542:: with SMTP id c2mr8069327ejd.533.1599729085432;
        Thu, 10 Sep 2020 02:11:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzDlmTUr6fJdtjDWNBypBMs7J2QrRY7INrpq4ulD5kRBc5YH6RHCcQDfHDuKW2yVlaRaNE9kA==
X-Received: by 2002:a17:906:1542:: with SMTP id c2mr8069317ejd.533.1599729085289;
        Thu, 10 Sep 2020 02:11:25 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:2744:1c91:fa55:fa01? ([2001:b07:6468:f312:2744:1c91:fa55:fa01])
        by smtp.gmail.com with ESMTPSA id br7sm6403283ejb.76.2020.09.10.02.11.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Sep 2020 02:11:24 -0700 (PDT)
Subject: Re: [PATCH 5/6] hw/pci-host/q35: Rename PCI 'black hole as '(memory)
 hole'
To:     Thomas Huth <thuth@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        qemu-devel@nongnu.org
Cc:     =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        kvm@vger.kernel.org, qemu-arm@nongnu.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Andrew Jeffery <andrew@aj.id.au>,
        Jason Wang <jasowang@redhat.com>,
        Alistair Francis <alistair@alistair23.me>,
        qemu-trivial@nongnu.org, Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Joel Stanley <joel@jms.id.au>
References: <20200910070131.435543-1-philmd@redhat.com>
 <20200910070131.435543-6-philmd@redhat.com>
 <7dbdef90-1ca6-bf27-7084-af0c716d01d9@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d04610d8-2ba3-4f36-2820-56044324a73d@redhat.com>
Date:   Thu, 10 Sep 2020 11:11:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <7dbdef90-1ca6-bf27-7084-af0c716d01d9@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/09/20 09:15, Thomas Huth wrote:
> On 10/09/2020 09.01, Philippe Mathieu-Daudé wrote:
>> In order to use inclusive terminology, rename "blackhole"
>> as "(memory)hole".
> A black hole is a well-known astronomical term, which is simply named
> that way since it absorbes all light. I doubt that anybody could get
> upset by this term?
> 

Agreed.  This is a memory region that absorbs all writes and always
reads as zero, the astronomical reference is obvious.

Paolo

