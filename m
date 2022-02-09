Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD8624AF20A
	for <lists+kvm@lfdr.de>; Wed,  9 Feb 2022 13:44:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233591AbiBIMo3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 07:44:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230053AbiBIMo1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 07:44:27 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 26887C0613CA
        for <kvm@vger.kernel.org>; Wed,  9 Feb 2022 04:44:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644410670;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=V7+vHM0ADJZ5fy9NoBUWaWS0D2M8fNyGswsV64PSMCM=;
        b=AL9cXGQWNiURFU7dcmJqB0cSjLpShS/1eMDqbMuhOWf1FZYt3geBuLTZdYVwYCsAXXAEZ3
        0dYtJOh7PyQD1k4agn+0clBoE5ot5tMWtPZd+vvZG0kF9VA+QlxVjyycWrR61MXibrDk/9
        bx6QKt+x2zKfeg2HreAFePBDb4voFLg=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-632-CFi7-vhDMXuI4pLWrIReNA-1; Wed, 09 Feb 2022 07:44:29 -0500
X-MC-Unique: CFi7-vhDMXuI4pLWrIReNA-1
Received: by mail-ej1-f69.google.com with SMTP id qq4-20020a17090720c400b006c6a6c55ed6so1121525ejb.12
        for <kvm@vger.kernel.org>; Wed, 09 Feb 2022 04:44:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=V7+vHM0ADJZ5fy9NoBUWaWS0D2M8fNyGswsV64PSMCM=;
        b=HcDtLRC728dqPVgHPeQ2Fp1ZxunDIA3zoUPpZ0O10oZp5orfaPHfdBCYrvNp4Njn+o
         RNQpN5fwmfVUsq3Hzm+a54kbZS26OLjpOULSiJ06WWudv8sEyOnGMSrSnIb7wu71fg5x
         N3v4rDRmYpd/6LUNqvI7jJ7tlF0CtQBXLrPBPINaVxX1AmrTDpLJSK1bnr+xQARM57Hc
         FmcqJul+MKZ/LMAIhSoq7Bv3Rpw6JFn7JQcpDsHZIJyK4da3XoyGE7BmOO1WpjkA3K26
         6IzA/d4vf6+7jkuYiRRDVTfzU2Jox2Rwmk25s9J337xSnkgUFy4nUCfRcvSyfkTiqcLE
         6bOA==
X-Gm-Message-State: AOAM530I6dS+1QTY7XSOaKWiclwN5WG1vRrb+UiDAFW4c8KtMOF+m0na
        +akcMcbWipLmlwXoDU+5cDmgpib+uuUgsTYhPBupK0g6TT8sZZpYngEzDsKFiNjNtMqDDiYOK6W
        QKje9V5rr+QAPHUFgq5FxIFDt8znMMDUX+UlhguRMk5R8pWZmDR3G/x3zYz6BIxlT
X-Received: by 2002:a17:907:160a:: with SMTP id hb10mr1787883ejc.306.1644410668177;
        Wed, 09 Feb 2022 04:44:28 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzW9CH5z/8qvh3CWJOahZcdsba4fCsAgDD01Wk3BdnXj3FogKgi4OBy6uRGcOZcf9Ow46oPDA==
X-Received: by 2002:a17:907:160a:: with SMTP id hb10mr1787869ejc.306.1644410667977;
        Wed, 09 Feb 2022 04:44:27 -0800 (PST)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id g6sm2432720ejx.165.2022.02.09.04.44.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Feb 2022 04:44:27 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: warning in kvm_hv_invalidate_tsc_page due to writes to guest
 memory from VM ioctl context
In-Reply-To: <YgKjDm5OdSOKIdAo@google.com>
References: <190b5932de7c61905d11c92780095a2caaefec1c.camel@redhat.com>
 <87ee4d9yp3.fsf@redhat.com>
 <060ce89597cfbc85ecd300bdd5c40bb571a16993.camel@redhat.com>
 <87bkzh9wkd.fsf@redhat.com> <YgKjDm5OdSOKIdAo@google.com>
Date:   Wed, 09 Feb 2022 13:44:26 +0100
Message-ID: <87wni48b11.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> On Tue, Feb 08, 2022, Vitaly Kuznetsov wrote:
>> Maxim Levitsky <mlevitsk@redhat.com> writes:
>> > and hv-avic only mentions AutoEOI feature.
>> 
>> True, this is hidden in "The enlightenment allows to use Hyper-V SynIC
>> with hardware APICv/AVIC enabled". Any suggestions on how to improve
>> this are more than welcome!.
>
> Specifically for the WARN, does this approach makes sense?
>
> https://lore.kernel.org/all/YcTpJ369cRBN4W93@google.com

(Sorry for missing this dicsussion back in December)

It probably does but the patch just introduces
HV_TSC_PAGE_UPDATE_REQUIRED flag and drops kvm_write_guest() completely,
the flag is never reset and nothing ever gets written to guest's
memory. I suppose you've forgotten to commit a hunk :-) This is good
starting poing though, I'll take a look.

-- 
Vitaly

