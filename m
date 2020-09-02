Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1524D25B313
	for <lists+kvm@lfdr.de>; Wed,  2 Sep 2020 19:41:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727115AbgIBRlr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Sep 2020 13:41:47 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:42113 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726990AbgIBRlm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Sep 2020 13:41:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599068500;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6xAT+ftsMSzlsQJaTtQj9xlDJAYlVlX6xJr8D9dNUi0=;
        b=GuG7pzR0vA0om8zLl/Av4ZC1KAYRvdiLAfLasnRtnjvZMZRsmRJtFSDO3Z4D5s6KG0arNp
        kkn8eSy2ay046MNW3ZyK5RI6Wvf4Y2jjjX5pOoUrFRGkwnhYzZ66yNR6H6yDIROJlNZ1lu
        s5c6uJUuGqrECoXhCtvRgBfAGf7DJ2U=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-576-WWHUfzVaPoi64ls5VMpBCg-1; Wed, 02 Sep 2020 13:41:39 -0400
X-MC-Unique: WWHUfzVaPoi64ls5VMpBCg-1
Received: by mail-wr1-f71.google.com with SMTP id g6so2367560wrv.3
        for <kvm@vger.kernel.org>; Wed, 02 Sep 2020 10:41:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6xAT+ftsMSzlsQJaTtQj9xlDJAYlVlX6xJr8D9dNUi0=;
        b=CmWa5Y06vphL1+0moX1n5noUm79qH+mJwIGs6JjrRlYGEvdbG2GaXzNFk3jErATs0c
         MxkLDOH4MB5FUHoS/6VkhfVry8A6D0+8/RB18EA/9UFKE/cAEX+gK6qw0G+9dxorRHUT
         uE7Oi2LpWb33WpLbB39T79cYy1fzaUeazYeMnDaPJPLT0MOwGmlwJUWQ7K941pNKObir
         KmFdjLmntC5Ewd1ROo3OccuGZt3CXrgbhiiCPMeS9ZVDq7AZ6Fc9Vz58dFqDpRnGEKJ+
         QXlS0/tD+JlFuB+kYYhqt6UBdSdhTv039izeUhqTpTcq7+WYW6zIOF+V8MvQ+b6O4B1j
         U02Q==
X-Gm-Message-State: AOAM531XyOMavbSSJ6R7C5NXqt3RwGopo0dRziQjmlD4WtaO23a0DGhV
        0H0eZxg4PGGxghz9vfwST7Doug2xSWdR0EmN8pmR/L+SK39SCXoNLEYTER4J4SXfnRHqyy65blA
        7X9CrZHSytc3H
X-Received: by 2002:a1c:f30f:: with SMTP id q15mr1732069wmq.60.1599068497782;
        Wed, 02 Sep 2020 10:41:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwJI4/fSfohZhzg0zq2mOil1DcOIoF66i9w6QgGSiGMttgmkpJk+kP5A0dUG4eAzfWa19MfuA==
X-Received: by 2002:a1c:f30f:: with SMTP id q15mr1732054wmq.60.1599068497518;
        Wed, 02 Sep 2020 10:41:37 -0700 (PDT)
Received: from [192.168.178.58] ([151.21.173.193])
        by smtp.gmail.com with ESMTPSA id j7sm601707wrw.35.2020.09.02.10.41.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Sep 2020 10:41:37 -0700 (PDT)
Subject: Re: [kvm-unit-tests GIT PULL 0/3] s390x skrf and ultravisor patches
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.vnet.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com
References: <20200901091823.14477-1-frankja@linux.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <34c80837-208f-bb29-cb0b-b9029fdad29d@redhat.com>
Date:   Wed, 2 Sep 2020 19:41:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200901091823.14477-1-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/09/20 11:18, Janosch Frank wrote:
>   git@gitlab.com:frankja/kvm-unit-tests.git tags/s390x-2020-01-09

Pulled, thanks.

(Yes, I am alive).

Paolo

