Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3CCD55F569
	for <lists+kvm@lfdr.de>; Wed, 29 Jun 2022 06:53:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbiF2ExM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jun 2022 00:53:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiF2ExL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jun 2022 00:53:11 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7B29F3A;
        Tue, 28 Jun 2022 21:53:07 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id e63so14202776pgc.5;
        Tue, 28 Jun 2022 21:53:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=references:user-agent:from:to:cc:subject:date:in-reply-to
         :message-id:mime-version;
        bh=vvrW+kUlTZ7MKpOPos9PlIMBtA7/T3veu3b/qNQ3HBk=;
        b=RWls3DRvSuIvp4MMFexG8NTzv3f1yWJIbObXr8wAJtU1b77K3wjS3hgzGiIV9baW5W
         g0jeNMYYxJ9WUnguMI0eghGrDXzZiJ2NkOdu5oHzaxhR6TfDkHu/lejMNdAmg9ICpPYM
         mmxwiGbUbFKadjN9UsyUopgydT5mMlfE2aMZMbghSYeCvnwOkXcj2u92diZ2bgvvS5qr
         /WNZQrj5JgLoB9vvsr0fQO5Cgc6ipOZ2xmg5fS/GMT0GrSPh4yHjHocFnetz1bEmRTIC
         ixEjpBMmmmQahyDb+kutGg2JVBqLkKbyZYYtsW1YTR7hcx84OpvCevyaH03iM+ZAApe7
         PUqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject:date
         :in-reply-to:message-id:mime-version;
        bh=vvrW+kUlTZ7MKpOPos9PlIMBtA7/T3veu3b/qNQ3HBk=;
        b=x5Vpt6m2Z+olqKQ6f8awRBhaMnGRgJsMoFICNb3mQClN6OqoACNcZDa8/sgnWQgvFo
         mOu7cyPxxbPbFfP4FEJTNBr+BWTZV8jX52//JAWUq48OVOCh3RHjy6qvx05D0K5J1WiQ
         kIYZt0WN0+onxffk6dlD3rIIptnHi+5i4NJa5HG+YnrieBz4E+fGJbtO4LjD0AI8rnS5
         /2naKZU2GpI3+Jd5KxlV8sbrBcG1C1o+nTf9g4eIZ7CrTV2E7W65m80jPl0dkYff9KmM
         EuI5jGBk0Ngr/Ne+0VUTtQC987dvB6RezD+rnKXHG4D3y23gYYsGKCt2af8jhdZwl7KI
         BJAQ==
X-Gm-Message-State: AJIora/jPIuGbAnDtRnFN9ZhWLOoyy0AUNIz9nuGh94Gzj4Rn+Kv58Jt
        1dZxzgpJrXVj6dy7vdhlKeTwhGbI3uX5Ew==
X-Google-Smtp-Source: AGRyM1tnQGZi67BTH5gEF2rN33/J4Y2Hvf2lwTTX4fq//ZWPUQYRzpCWWL/0D6hWTbaGZsbsk0j0ag==
X-Received: by 2002:a63:8b43:0:b0:40d:1da6:948e with SMTP id j64-20020a638b43000000b0040d1da6948emr1372257pge.355.1656478386887;
        Tue, 28 Jun 2022 21:53:06 -0700 (PDT)
Received: from MBP ([39.170.101.209])
        by smtp.gmail.com with ESMTPSA id ip11-20020a17090b314b00b001ec84b0f199sm4990001pjb.1.2022.06.28.21.53.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 21:53:06 -0700 (PDT)
References: <20220628152429.286-1-schspa@gmail.com>
 <20220628095013.266d4a40.alex.williamson@redhat.com>
 <87ilokbx12.fsf@redhat.com>
User-agent: mu4e 1.6.10; emacs 27.2
From:   Schspa Shi <schspa@gmail.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] vfio: Clear the caps->buf to NULL after free
Date:   Wed, 29 Jun 2022 12:51:51 +0800
In-reply-to: <87ilokbx12.fsf@redhat.com>
Message-ID: <m2h744rryw.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Cornelia Huck <cohuck@redhat.com> writes:

> On Tue, Jun 28 2022, Alex Williamson 
> <alex.williamson@redhat.com> wrote:
>
>> On Tue, 28 Jun 2022 23:24:29 +0800
>> Schspa Shi <schspa@gmail.com> wrote:
>>
>>> API vfio_info_cap_add will free caps->buf, clear it to NULL 
>>> after
>>> free.
>>
>> Should this be something like:
>>
>>     On buffer resize failure, vfio_info_cap_add() will free the 
>>     buffer,
>>     report zero for the size, and return -ENOMEM.  As 
>>     additional
>>     hardening, also clear the buffer pointer to prevent any 
>>     chance of a
>>     double free.
>
> I like that better. With that,
>
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
>

I have send a V3 patch for this comment change, please review it.

>>
>> Thanks,
>> Alex
>>  
>>> Signed-off-by: Schspa Shi <schspa@gmail.com>
>>> ---
>>>  drivers/vfio/vfio.c | 1 +
>>>  1 file changed, 1 insertion(+)
>>> 
>>> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
>>> index 61e71c1154be..a0fb93866f61 100644
>>> --- a/drivers/vfio/vfio.c
>>> +++ b/drivers/vfio/vfio.c
>>> @@ -1812,6 +1812,7 @@ struct vfio_info_cap_header 
>>> *vfio_info_cap_add(struct vfio_info_cap *caps,
>>>  	buf = krealloc(caps->buf, caps->size + size, GFP_KERNEL);
>>>  	if (!buf) {
>>>  		kfree(caps->buf);
>>> +		caps->buf = NULL;
>>>  		caps->size = 0;
>>>  		return ERR_PTR(-ENOMEM);
>>>  	}

-- 
BRs
Schspa Shi
