Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72DAFF4285
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2019 09:49:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728513AbfKHItF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Nov 2019 03:49:05 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:54732 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725975AbfKHItE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 8 Nov 2019 03:49:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573202943;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=opGy4doVYidYacou9lawqqOlVyY89OwzZVPLlNR9M5g=;
        b=YbnOYTqNU+0ot54c2inrpw7bvN048/mNPYhcOka5b4vHWq44zQmrr5TUI8sR+r8Z7sk46f
        XeF719lIwE97cE2SUXfgrCrPlgPw7j07QjJADvC+crooAyWjmZ5xlVWuw2qXb4YeoGxk71
        uXe3YCcW/IPB7I1PQVIRFrnA0QldPxU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-34-6C9tTRZ6PhW0d5SSTAfDRg-1; Fri, 08 Nov 2019 03:49:00 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 01D09477;
        Fri,  8 Nov 2019 08:48:59 +0000 (UTC)
Received: from localhost.localdomain (ovpn-116-167.ams2.redhat.com [10.36.116.167])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D4F1C5DA70;
        Fri,  8 Nov 2019 08:48:57 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v3 4/6] Makefile: add "cxx-option" for C++
 builds
To:     Bill Wendling <morbo@google.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com
Cc:     jmattson@google.com, sean.j.christopherson@intel.com
References: <20191015000411.59740-1-morbo@google.com>
 <20191030210419.213407-1-morbo@google.com>
 <20191030210419.213407-5-morbo@google.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <3f1b2a69-aada-6375-4443-e2132369a4b2@redhat.com>
Date:   Fri, 8 Nov 2019 09:48:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20191030210419.213407-5-morbo@google.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: 6C9tTRZ6PhW0d5SSTAfDRg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/10/2019 22.04, Bill Wendling wrote:
> The C++ compiler may not support all of the same flags as the C
> compiler. Add a separate test for these flags.
>=20
> Signed-off-by: Bill Wendling <morbo@google.com>
> ---
>   Makefile | 14 +++++++++++++-
>   1 file changed, 13 insertions(+), 1 deletion(-)
>=20
> diff --git a/Makefile b/Makefile
> index 6201c45..9cb47e6 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -48,6 +48,8 @@ include $(SRCDIR)/$(TEST_DIR)/Makefile
>  =20
>   cc-option =3D $(shell if $(CC) -Werror $(1) -S -o /dev/null -xc /dev/nu=
ll \
>                 > /dev/null 2>&1; then echo "$(1)"; else echo "$(2)"; fi =
;)
> +cxx-option =3D $(shell if $(CXX) -Werror $(1) -S -o /dev/null -xc++ /dev=
/null \
> +              > /dev/null 2>&1; then echo "$(1)"; else echo "$(2)"; fi ;=
)
>  =20
>   COMMON_CFLAGS +=3D -g $(autodepend-flags)
>   COMMON_CFLAGS +=3D -Wall -Wwrite-strings -Wempty-body -Wuninitialized
> @@ -73,9 +75,19 @@ COMMON_CFLAGS +=3D $(wclobbered)
>   COMMON_CFLAGS +=3D $(wunused_but_set_parameter)
>  =20
>   CFLAGS +=3D $(COMMON_CFLAGS)
> +CXXFLAGS +=3D $(COMMON_CFLAGS)
> +
> +wmissing_parameter_type :=3D $(call cc-option, -Wmissing-parameter-type,=
 "")
> +wold_style_declaration :=3D $(call cc-option, -Wold-style-declaration, "=
")
> +CFLAGS +=3D $(wmissing_parameter_type)
> +CFLAGS +=3D $(wold_style_declaration)
>   CFLAGS +=3D -Woverride-init -Wmissing-prototypes -Wstrict-prototypes
>  =20
> -CXXFLAGS +=3D $(COMMON_CFLAGS)
> +# Clang's C++ compiler doesn't support some of the flags its C compiler =
does.
> +wmissing_parameter_type :=3D $(call cxx-option, -Wmissing-parameter-type=
, "")
> +wold_style_declaration :=3D $(call cxx-option, -Wold-style-declaration, =
"")
> +CXXFLAGS +=3D $(wmissing_parameter_type)
> +CXXFLAGS +=3D $(wold_style_declaration)

According to the man page of gcc-9, both options are for "C and=20
Objective-C only". I think you can simply always remove them from the=20
CXXFLAGS.

  Thomas

