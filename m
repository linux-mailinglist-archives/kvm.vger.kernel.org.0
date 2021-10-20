Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D888D434EE7
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 17:19:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230314AbhJTPWK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 11:22:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44765 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229570AbhJTPWJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Oct 2021 11:22:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634743195;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yyZz6tPzl6xlxSVrX/eaS6XLIFeKvUdIla9YE8OM4eQ=;
        b=jUcQpYKiA8wN0n66+MUSJwYNHvDwCsCGf4BraeZgRx5vPN9X8XMz1OlhI+qRCF30bCpfxR
        CopTQgOYHg6OfbbgGCnNHb9jPeiNFGC6wOcIGjBLbefvODuTBuhLPxHyM1FmzlSreSRBHl
        G9Kax60+7SMp3DnXRIeJ0m+FP/oAtlo=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-502-o1ixXFfnMFavB8N0ouEfmg-1; Wed, 20 Oct 2021 11:19:53 -0400
X-MC-Unique: o1ixXFfnMFavB8N0ouEfmg-1
Received: by mail-ed1-f69.google.com with SMTP id f4-20020a50e084000000b003db585bc274so21281052edl.17
        for <kvm@vger.kernel.org>; Wed, 20 Oct 2021 08:19:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=yyZz6tPzl6xlxSVrX/eaS6XLIFeKvUdIla9YE8OM4eQ=;
        b=DXNZr3kbGf50XsemH7oroCc43OTZuf5Nu9m7Z/BfPKqAYZCFy5Juenw+kcQgtYHHMd
         7D1/LsYq7498VkjHzTJ24PMVDcbGgx3unp/WR2PM8O9n/w0Kj8MUD483FG5HnLV2kAnM
         wx9BLsUoMz1LnYiZKRar8IASL0Jl7iwzDMuux9+5QYRyBeRpHWbmB1PhnBKujrldAgiu
         PYEAFGbUyaN2n1w4wBfiB6B7V/V/9xBsH84WcZylC95Qth+FsQywcQEDwzqMfjGyAwP5
         EHLXYWGa0Ozpe5TqPV9JW4XBavzaw2wJpW79yNkHrS23pYcNS3MFWwjNKjRX73nRkk7n
         qJ+g==
X-Gm-Message-State: AOAM530TDMmMlRQS7xATDVPxmzUNkrxAFhRIR8ggmylVb3d18ZfNDbjo
        ETO2Cqx+jk7sNkl72igq4+FYXl3sIvehIMXNzq3sCO0TCTVLkW4sUIwtXsLJCO3druu8Yvys3R8
        MQzins6FrquiD
X-Received: by 2002:a17:906:a404:: with SMTP id l4mr190462ejz.175.1634743192379;
        Wed, 20 Oct 2021 08:19:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwGuhrEAl2zjz2Jlv3sDIQcUMILogZT8SkaoaOZpN9H0TJk//mtJqlja6beP6/8r/9o5aUgSA==
X-Received: by 2002:a17:906:a404:: with SMTP id l4mr190443ejz.175.1634743192179;
        Wed, 20 Oct 2021 08:19:52 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id kw10sm1219686ejc.71.2021.10.20.08.19.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Oct 2021 08:19:51 -0700 (PDT)
Message-ID: <97edef2b-7327-c1fe-8b18-c51f1473f17e@redhat.com>
Date:   Wed, 20 Oct 2021 17:19:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [TEST PATCH] KVM: selftests: Add a test case for debugfs
 directory
Content-Language: en-US
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>, kvm@vger.kernel.org
References: <20210827234817.60364-1-krish.sadhukhan@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20210827234817.60364-1-krish.sadhukhan@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/08/21 01:48, Krish Sadhukhan wrote:
>   
> +	/*
> +	 * Check debugfs directory for every VM and VCPU
> +	 */
> +	struct stat buf;
> +	int len;
> +	char *vm_dir_path = NULL;
> +	char *vcpu_dir_path = NULL;
> +
> +	len = strlen(KVM_DEBUGFS_PATH) + 2 * INT_MAX_LEN + 3;
> +	vm_dir_path = malloc(len);
> +	TEST_ASSERT(vm_dir_path, "Allocate memory for VM directory path");
> +	vcpu_dir_path = malloc(len + INT_MAX_LEN + 6);
> +	TEST_ASSERT(vm_dir_path, "Allocate memory for VCPU directory path");
> +	for (i = 0; i < max_vm; ++i) {
> +		sprintf(vm_dir_path, "%s/%d-%d", KVM_DEBUGFS_PATH, getpid(),
> +			vm_get_fd(vms[i]));
> +		stat(vm_dir_path, &buf);
> +		TEST_ASSERT(S_ISDIR(buf.st_mode), "VM directory %s does not exist",
> +			    vm_dir_path);
> +		for (j = 0; j < max_vcpu; ++j) {
> +			sprintf(vcpu_dir_path, "%s/vcpu%d", vm_dir_path, j);
> +			stat(vcpu_dir_path, &buf);
> +			TEST_ASSERT(S_ISDIR(buf.st_mode), "VCPU directory %s does not exist",
> +				    vcpu_dir_path);
> +		}
> +	}
> +

Hi,

please ensure that the tests don't fail if thy don't run as root.

Paolo

