Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DDB115D594
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2020 11:27:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387445AbgBNK1W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Feb 2020 05:27:22 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:25931 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387397AbgBNK1V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Feb 2020 05:27:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581676040;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YdFEsFZTsp4ctnOuNfmw9rCMIBHph23anfVTabWmzIc=;
        b=MHF5W8EMTSuofwHQhFOri/Mn4lkfqHCD5dCMhS4HIKA+HTVIGeb+Jhld5nDdyAh3JmA4QN
        r2RAwg+hEliCGkfUsjrykAWCXrvd5ODx49GLqC+YC25UDRga164EGyktDb48xr/2PXyOfF
        RA5pG9CJTdgt8JSE+wrrL8fCT8Qgky8=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-5-tz7w2qkcNKibY9mQORPAlA-1; Fri, 14 Feb 2020 05:27:19 -0500
X-MC-Unique: tz7w2qkcNKibY9mQORPAlA-1
Received: by mail-wr1-f70.google.com with SMTP id p8so3791165wrw.5
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2020 02:27:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YdFEsFZTsp4ctnOuNfmw9rCMIBHph23anfVTabWmzIc=;
        b=n5LUbzh7ovXDCc1PMCENXtWMcrLwmMreYK5pmFWGYeiBM573RaSju3ZFEJtKHFx8ru
         U22KepTt27Os2apDGMUEsXb718fkFpciLU0Zh+nq+d2IZblYMXHXsZ7kQeiAzuuInYE4
         XvKbPf0fkp8DLsVHMs2vdk9YsizXNV4BzvF/7degmZrTAIQS8WJHa+ktS7dYOUXZuLjO
         E8gpEKoXM/wiLTf9lUnL1CS01mjo7+68PRd7pOALlY7zJh9SsZnTFE7SBDcphAY7TtvE
         Re+a0BRq8jKLYE93JnkVBk0/Bs9PBQp4KFe1eS4J7fn27K2zPfZ2lfmE5Fbkg6npJe0v
         SQyw==
X-Gm-Message-State: APjAAAXJy7tqbLcJ4RUcCeKEhy40TB+0ZKfIqs2GMYbAS1beRmpWWVo+
        Hr8hmG5y3R0pM13GgIRjFGWU6fGq4Frs54Ail1SAfrGYU3m2gEtm9R6uXxj8Z8OJBmK/0BnQv2k
        F6sMkDLe6Q2wj
X-Received: by 2002:a1c:1fc5:: with SMTP id f188mr4060610wmf.55.1581676037656;
        Fri, 14 Feb 2020 02:27:17 -0800 (PST)
X-Google-Smtp-Source: APXvYqzEPYxY0+Trlupzg7ndgImqmsmqlitBQCW4zVZczR5cXfnmkGzx05+J2pdyksNhDjIAPS3e1Q==
X-Received: by 2002:a1c:1fc5:: with SMTP id f188mr4060588wmf.55.1581676037442;
        Fri, 14 Feb 2020 02:27:17 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:59c7:c3ee:2dec:d2b4? ([2001:b07:6468:f312:59c7:c3ee:2dec:d2b4])
        by smtp.gmail.com with ESMTPSA id w11sm6618381wrt.35.2020.02.14.02.27.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Feb 2020 02:27:17 -0800 (PST)
Subject: Re: [PATCH kvm-unit-tests 2/2] runtime: Introduce VMM_PARAMS
To:     Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org
Cc:     peter.maydell@linaro.org, alex.bennee@linaro.org,
        lvivier@redhat.com, thuth@redhat.com, david@redhat.com,
        frankja@linux.ibm.com, eric.auger@redhat.com
References: <20200213143300.32141-1-drjones@redhat.com>
 <20200213143300.32141-3-drjones@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <689d8031-22ac-c414-a3c3-e10567c3c9af@redhat.com>
Date:   Fri, 14 Feb 2020 11:27:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200213143300.32141-3-drjones@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/02/20 15:33, Andrew Jones wrote:
> Users may need to temporarily provide additional VMM parameters.
> The VMM_PARAMS environment variable provides a way to do that.
> We take care to make sure when executing ./run_tests.sh that
> the VMM_PARAMS parameters come last, allowing unittests.cfg
> parameters to be overridden. However, when running a command
> line like `$ARCH/run $TEST $PARAMS` we want $PARAMS to override
> $VMM_PARAMS, so we ensure that too.
> 
> Additional QEMU parameters can still be provided by appending
> them to the $QEMU environment variable when it provides the
> path to QEMU, but as those parameters will then be the first
> in the command line they cannot override anything, and may
> themselves be overridden.

What about looking for "--" and passing to QEMU all parameters after it?

Paolo

