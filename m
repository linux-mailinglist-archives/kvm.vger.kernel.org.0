Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AB62365440
	for <lists+kvm@lfdr.de>; Tue, 20 Apr 2021 10:38:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230395AbhDTIjE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Apr 2021 04:39:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:45568 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229593AbhDTIjD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 20 Apr 2021 04:39:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618907912;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=F95o+fNoPCFl024nha++58pjDRxnjtUMH0v5H3RPK8s=;
        b=LFHJpYs/V55wc0XX3zVCLiIp8sofWVI+TALcK5i7K3hJ3iQ7Yx47lCNMoJu1FuhKWXrDR/
        9GLn0h3zZRx+lXU/QMQM7CmXO5rUi9ajtZn99x85KevMiovs52rPXMRMJSyeQ7Bjge5eoT
        pAasbkjjLgO5Z3gO2yheM4mt0N3ndQA=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-126-4mePuduLOQS6x02TxTbohA-1; Tue, 20 Apr 2021 04:38:30 -0400
X-MC-Unique: 4mePuduLOQS6x02TxTbohA-1
Received: by mail-ed1-f70.google.com with SMTP id h13-20020a05640250cdb02903790a9c55acso12701405edb.4
        for <kvm@vger.kernel.org>; Tue, 20 Apr 2021 01:38:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=F95o+fNoPCFl024nha++58pjDRxnjtUMH0v5H3RPK8s=;
        b=QTMtCKvErYAcEvSFfUGk7n+z5uSgV4VY3YImTOhRsrnWPIfUTi6ayRAu993HCfr2Yx
         33RcXJBKCpCHhuabxf8Pg0CVTwmUVQQ3nDyFZnerVvOp3Q6r407l5Bb3id9L3Y74SUZh
         GhYfrQ57G+jw2Ltvo/Akd2xnemwjChUTc5E0S9bCRAtSW4waFgOjNRx8HByWPFvgNqC0
         GRE0tRKqU1J9c5Qohgmm8++wIkxE2GSr87zB37OND8FwoVOXP94l/0C/l/binUqd5R2H
         0khrSbEk08gs8er9WW+m43WEJCQkl1CDairpZwbBIdkAuEnBQ3yU/6Y4MfXQa7omdA1O
         qOuQ==
X-Gm-Message-State: AOAM533iByQNgkcXMBQJeb0K5+I43Sn+SPb9bRNzsHJJJh0+rQfIWiwo
        2kmCury9b6rnNFD8g4OjU+pgV3Usnva1NhR5wfcTlLp/4d54Wrqee/mMsHjBONEKuN0OhPdxTSe
        FYn33CCOCvoK4
X-Received: by 2002:a17:906:b6c5:: with SMTP id ec5mr26333974ejb.290.1618907909346;
        Tue, 20 Apr 2021 01:38:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxB58mtjaGALQrmxS1QokEn7JNYZxMS+PoplUpz54knbUm+5VJwkIMDUSxwE8Q4g2wDL+vuTg==
X-Received: by 2002:a17:906:b6c5:: with SMTP id ec5mr26333962ejb.290.1618907909225;
        Tue, 20 Apr 2021 01:38:29 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id gu14sm10575030ejb.114.2021.04.20.01.38.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Apr 2021 01:38:28 -0700 (PDT)
Subject: Re: [PATCH v13 04/12] KVM: SVM: Add support for KVM_SEV_RECEIVE_START
 command
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, seanjc@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
References: <cover.1618498113.git.ashish.kalra@amd.com>
 <c7400111ed7458eee01007c4d8d57cdf2cbb0fc2.1618498113.git.ashish.kalra@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8cade407-0141-3757-abd8-4399912741eb@redhat.com>
Date:   Tue, 20 Apr 2021 10:38:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <c7400111ed7458eee01007c4d8d57cdf2cbb0fc2.1618498113.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/04/21 17:54, Ashish Kalra wrote:
> +	}
> +
> +	sev->handle = start->handle;
> +	sev->fd = argp->sev_fd;

These two lines are spurious, I'll delete them.

Paolo

