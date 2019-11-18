Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84383100235
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2019 11:18:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726506AbfKRKSS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Nov 2019 05:18:18 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:52678 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726460AbfKRKSR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Nov 2019 05:18:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574072296;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=2E3zGvcBzTUcLhpxKfOcu9Ms2VjdQXXDxg4LgjxU4cY=;
        b=WUuPqVvE3pe5UhVUaiEVzClhAClFjuYPHQlCrkXVHrGVY8Fa7zUmNeKnLCxlz0GF5c5wwe
        7P13vjU25kPukRFarCm9hEPhehceOqPKCgc8Oshdn5KmTkBMQ+zt1CR4oNR7DvoynVSq2E
        qCZAloVo0yQ3Vcg/xBVfDTkFFJ+cz4A=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-94-bsPBLE6KOS2ORBOrPw_sNw-1; Mon, 18 Nov 2019 05:18:13 -0500
Received: by mail-wr1-f71.google.com with SMTP id e3so15059165wrs.17
        for <kvm@vger.kernel.org>; Mon, 18 Nov 2019 02:18:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NUX8CeNVsMpg2rxsEpL/fpGBcxg3BWxo3mZefOvTINk=;
        b=A3VuiyNTI4BpfXbhuGMI8nzBk8aoBY0rw0nEV6faughhu+w+iv5IDBxyXSUz94w0JO
         8MyOu+XjVo2jRAoSzhjzDX9CfwFAR0/6bxSRDOrwWlc41h0JmVF5doFUXbM+pz8ZJES4
         0QLxqXjP2U3dqA2rfviMaj/qsl8iLuwhwR2w7vZ7cTycZYHO1jYHJWAxqaDoNajtYpCK
         UKkJ+uY4x4m2RxI41e2odEJQeuoFSDDtGYoOi90FUfXU7d7+GAAginQIZGZLGUd6XBJd
         87Ru/PF9oRA73InDLFHC3IFIxVcfa8JpIOnAQ95So5G0jpp/7t1bC0YPhOqQRDsWCfj8
         TXLA==
X-Gm-Message-State: APjAAAX28vifaUJEjDBCrSCUHOISlrBtKPvntY8ulin1JfUQakT2Z8lu
        kZea+P4NrcD+EtQjzpXmeKwezrSeifhzSuJBjgTSaBjYVIyVbp8RUmMwAYn7NNn9qAJurSD9BCb
        FYdcrU3iyMkAR
X-Received: by 2002:a05:600c:489:: with SMTP id d9mr16089208wme.20.1574072292021;
        Mon, 18 Nov 2019 02:18:12 -0800 (PST)
X-Google-Smtp-Source: APXvYqxiD+WufhFIR18R5qHmYm4WnrDMHd+vwAEjPuAJUZQ2UUYnNrw1gUpBslV0U1a4V+Vj4OhcmA==
X-Received: by 2002:a05:600c:489:: with SMTP id d9mr16089166wme.20.1574072291742;
        Mon, 18 Nov 2019 02:18:11 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:a15b:f753:1ac4:56dc? ([2001:b07:6468:f312:a15b:f753:1ac4:56dc])
        by smtp.gmail.com with ESMTPSA id j2sm22693993wrt.61.2019.11.18.02.18.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Nov 2019 02:18:11 -0800 (PST)
Subject: Re: [kvm-unit-tests PULL 00/12] s390x and Travis CI updates
To:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org
Cc:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>
References: <20191118100719.7968-1-david@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <390f8a03-fdb1-b67b-1342-e6714ba24ba1@redhat.com>
Date:   Mon, 18 Nov 2019 11:18:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191118100719.7968-1-david@redhat.com>
Content-Language: en-US
X-MC-Unique: bsPBLE6KOS2ORBOrPw_sNw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/11/19 11:07, David Hildenbrand wrote:
>   https://github.com/davidhildenbrand/kvm-unit-tests.git tags/s390x-2019-=
11-18

Pulled, thanks.

Paolo

