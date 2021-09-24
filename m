Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03FF3417212
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 14:42:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343590AbhIXMoO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 08:44:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58106 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245067AbhIXMoO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 24 Sep 2021 08:44:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632487360;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+DbPseb+Ku4ZG2Ck4gbO4CHo4uMS9awfZWTfvg2MZDk=;
        b=MytSshmAOiZIhRsN0286At7NwsebTw5YbSSPgDF5jX3wQW4y1QRX3NkMXFAXIv6Ud4rgEZ
        G49jfamoDgixAagsXdS54KvYOhyiCiOXijf4GkvJ0AlPZSjRWBF+LQRwqJDpszCSrb0Tuy
        NGz1ZLWoUnMXdGa26huYZ0LWovDciiE=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-558-KN_8sQOCMh2jBsEKyhieEw-1; Fri, 24 Sep 2021 08:42:39 -0400
X-MC-Unique: KN_8sQOCMh2jBsEKyhieEw-1
Received: by mail-ed1-f70.google.com with SMTP id h6-20020a50c386000000b003da01adc065so10090958edf.7
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 05:42:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+DbPseb+Ku4ZG2Ck4gbO4CHo4uMS9awfZWTfvg2MZDk=;
        b=OymkZNVunoU4J4amfxu0icY7j1Pl7wTN0OPnb00He9YAE+Ir0LVtyAuDcIpDiAZYKJ
         KfbVRkFLUoqMfemyDhCJvuV0qJknRYRXXadjaibpj9p/D75DLMjK/1y+vCxw09zQCI8Y
         o5jD2ZnnCMYWTdqtw7H5Iuif+/S2Ubqkw86aB9y5usnARqb+RjSkak7CXMRImudX3Wi8
         95HewJBty9Nmc0HRnPnI2wXHIBlGbT4DDqtkl3mp51chgBQ2ZcJry///hk+nFbLQPQTk
         bbbPRe3VvPotL1IHXAfhURIftwy9dxD8qRf4vx07uHBhR0i4jqSlsg9MX+b8PMZC9VGt
         NSeA==
X-Gm-Message-State: AOAM533QhlU86G2brl9DBdmC1LjRwOVODDiumgIx8mZCNsgjAisoNiHS
        ivk3JiRKBmym0h1psOn6uw8oKG1pn/RpLgxhBtflxHqPoa7JM9dLOPc+rygNCO9mbPxG6NjU3QS
        7OwEI1qLJSX1S
X-Received: by 2002:a17:907:3f18:: with SMTP id hq24mr11055802ejc.384.1632487358422;
        Fri, 24 Sep 2021 05:42:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyE7pP/F9tSw2VZ7xmyZg1PccW052HMpeJU3ILiD3SY6HzmwnXpfCwoL12oJbJrOHZAvCxe4g==
X-Received: by 2002:a17:907:3f18:: with SMTP id hq24mr11055791ejc.384.1632487358292;
        Fri, 24 Sep 2021 05:42:38 -0700 (PDT)
Received: from gator.home (cst2-174-28.cust.vodafone.cz. [31.30.174.28])
        by smtp.gmail.com with ESMTPSA id y8sm5062718ejm.104.2021.09.24.05.42.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 05:42:37 -0700 (PDT)
Date:   Fri, 24 Sep 2021 14:42:35 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Laurent Vivier <lvivier@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [PATCH kvm-unit-tests] MAINTAINERS: add S lines
Message-ID: <20210924124235.g7vhlajzcu4t6d2o@gator.home>
References: <20210923114814.229844-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210923114814.229844-1-pbonzini@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 23, 2021 at 01:48:14PM +0200, Paolo Bonzini wrote:
> Mark PPC as maintained since it is a bit more stagnant than the rest.
> 
> Everything else is supported---strange but true.
> 
> Cc: Laurent Vivier <lvivier@redhat.com>
> Cc: Thomas Huth <thuth@redhat.com>
> Cc: Janosch Frank <frankja@linux.ibm.com>
> Cc: Andrew Jones <drjones@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  MAINTAINERS | 5 +++++
>  1 file changed, 5 insertions(+)
>

Acked-by: Andrew Jones <drjones@redhat.com>

