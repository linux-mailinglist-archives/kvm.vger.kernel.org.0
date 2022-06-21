Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB7E0553785
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 18:12:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353776AbiFUQLo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 12:11:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353693AbiFUQLn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 12:11:43 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B7FD2A410
        for <kvm@vger.kernel.org>; Tue, 21 Jun 2022 09:11:42 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id t3-20020a17090a510300b001ea87ef9a3dso13872774pjh.4
        for <kvm@vger.kernel.org>; Tue, 21 Jun 2022 09:11:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zGylr5kHbXSHDko9d+57WcI0WwchyF7hKhBxsVs1vPI=;
        b=abxuD3kcoJtJVbJaDXlXWSFZLVTyKzPoj+HkYha/Wy2s/8l22q1ecLeO2fEdilN5F1
         wlaY3KWknP3U+grWZ3iep+Ifp+nRDq+h9tpnKEfLydyU/1hX39ePoZWqPQerDHTxmpD0
         sN5BgqXod4J841D2DPvUax+OygXG3CztCUl/ibXVux+VM8mYQDXzzTdpLllvbSbBQk0C
         rh/1mbtMhLM3UnZ776wY7qNPBqtuRBqsHFUhHjZF7IFMNboJuIvCYWq7D3fr7v5ltGM3
         +erc5Id637/CSCxwa7Qz9X7PL1QTUmsgDr57jqLbFqLGpqLy7BdFbsBs+LI/LYpObLBT
         7kTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zGylr5kHbXSHDko9d+57WcI0WwchyF7hKhBxsVs1vPI=;
        b=hujlAZhmK6Z9Fxo2iDQlc1FcP0Zhgg3yt6eqzLcqLTYrk5FIVv9Sq4Xh18RuWmrT1s
         cYjePI/8kXIzf45SQQ/GYDMrfacAMk2ze1Yozt2PUpgYslhqZeWlyQTnfK7vOCv4hArW
         C9NuzkAkovTPiYEzYHSPWmARgFM+jv5+K8IK2fgvOfDNquVL0HWUZDtICHtzq7GPapdy
         H8iCIYqcZchp+gqKTfKRLIe5dimJQsDt1ndHj9594OZcDwXeulDj09LHuG+v8KPMDr8R
         xX0Trw8sVqkfgt5qAh7zKy7ao+HGED0SoMR8INWofMS9t1cbksRI8HdViwJeovRKk++e
         SH/w==
X-Gm-Message-State: AJIora8KLJsT2XSuRQCI2KAPkkDs0+hthVpPs4FH06Xp4V/ucuO792Gi
        8MTVHfYstEnzUJHV99Gpo0EQtW0WZyoCwg==
X-Google-Smtp-Source: AGRyM1uHPcGQcPJXCBQlGJX1O0hmeP2qzTnPWlLZT4kk1AiBPXwXX6yxpNfuEvfVIeBOuERVVPG7Ag==
X-Received: by 2002:a17:902:d4c5:b0:16a:44c0:4f9c with SMTP id o5-20020a170902d4c500b0016a44c04f9cmr244548plg.15.1655827901778;
        Tue, 21 Jun 2022 09:11:41 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id je21-20020a170903265500b001690d283f52sm9850939plb.158.2022.06.21.09.11.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jun 2022 09:11:41 -0700 (PDT)
Date:   Tue, 21 Jun 2022 09:11:37 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc:     kvm@vger.kernel.org, drjones@redhat.com, pbonzini@redhat.com,
        jade.alglave@arm.com, alexandru.elisei@arm.com
Subject: Re: [kvm-unit-tests PATCH v2 10/23] lib/printf: Add support for
 printing wide strings
Message-ID: <YrHtuduL5GtgSQuh@google.com>
References: <20220506205605.359830-1-nikos.nikoleris@arm.com>
 <20220506205605.359830-11-nikos.nikoleris@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220506205605.359830-11-nikos.nikoleris@arm.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 06, 2022 at 09:55:52PM +0100, Nikos Nikoleris wrote:
> This change adds support for wide strings (u16*) to printf()
> variants. This feature is used by a future change.
> 
> Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> ---
>  lib/printf.c | 101 ++++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 100 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/printf.c b/lib/printf.c
> index 724befa..14a3fed 100644
> --- a/lib/printf.c
> +++ b/lib/printf.c
> @@ -57,6 +57,102 @@ static void print_str(pstream_t *p, const char *s, strprops_t props)
>      }
>  }
>  
> +/*
> + * Adapted from drivers/firmware/efi/libstub/vsprintf.c
> + */
> +static u32 utf16_to_utf32(const u16 **s16)
> +{
> +    u16 c0, c1;
> +
> +    c0 = *(*s16)++;
> +    /* not a surrogate */
> +    if ((c0 & 0xf800) != 0xd800)
> +	return c0;
> +    /* invalid: low surrogate instead of high */
> +    if (c0 & 0x0400)
> +	return 0xfffd;
> +    c1 = **s16;
> +    /* invalid: missing low surrogate */
> +    if ((c1 & 0xfc00) != 0xdc00)
> +	return 0xfffd;
> +    /* valid surrogate pair */
> +    ++(*s16);
> +    return (0x10000 - (0xd800 << 10) - 0xdc00) + (c0 << 10) + c1;
> +}
> +
> +/*
> + * Adapted from drivers/firmware/efi/libstub/vsprintf.c
> + */
> +static size_t utf16s_utf8nlen(const u16 *s16, size_t maxlen)
> +{
> +    size_t len, clen;
> +
> +    for (len = 0; len < maxlen && *s16; len += clen) {
> +	u16 c0 = *s16++;
> +
> +	/* First, get the length for a BMP character */
> +	clen = 1 + (c0 >= 0x80) + (c0 >= 0x800);
> +	if (len + clen > maxlen)
> +	    break;
> +	/*
> +	 * If this is a high surrogate, and we're already at maxlen, we
> +	 * can't include the character if it's a valid surrogate pair.
> +	 * Avoid accessing one extra word just to check if it's valid
> +	 * or not.
> +	 */
> +	if ((c0 & 0xfc00) == 0xd800) {
> +	    if (len + clen == maxlen)
> +		break;
> +	    if ((*s16 & 0xfc00) == 0xdc00) {
> +		++s16;
> +		++clen;
> +	    }
> +	}
> +    }
> +
> +    return len;
> +}
> +
> +/*
> + * Adapted from drivers/firmware/efi/libstub/vsprintf.c
> + */
> +static void print_wstring(pstream_t *p, const u16 *s, strprops_t props)
> +{
> +    const u16 *ws = (const u16 *)s;
> +    size_t pos = 0, size = p->remain + 1, len = utf16s_utf8nlen(ws, props.precision);
> +
> +    while (len-- > 0) {
> +	u32 c32 = utf16_to_utf32(&ws);
> +	u8 *s8;
> +	size_t clen;
> +
> +	if (c32 < 0x80) {
> +	    addchar(p, c32);
> +	    continue;
> +	}
> +
> +	/* Number of trailing octets */
> +	clen = 1 + (c32 >= 0x800) + (c32 >= 0x10000);
> +
> +	len -= clen;
> +	s8 = (u8 *)(p->buffer - p->added + pos);
> +
> +	/* Avoid writing partial character */
> +	addchar(p, '\0');
> +	pos += clen;
> +	if (pos >= size)
> +	    continue;
> +
> +	/* Set high bits of leading octet */
> +	*s8 = (0xf00 >> 1) >> clen;
> +	/* Write trailing octets in reverse order */
> +	for (s8 += clen; clen; --clen, c32 >>= 6)
> +	    *s8-- = 0x80 | (c32 & 0x3f);
> +	/* Set low bits of leading octet */
> +	*s8 |= c32;
> +    }
> +}
> +
>  static char digits[16] = "0123456789abcdef";
>  
>  static void print_int(pstream_t *ps, long long n, int base, strprops_t props)
> @@ -302,7 +398,10 @@ int vsnprintf(char *buf, int size, const char *fmt, va_list va)
>  	    print_unsigned(&s, (unsigned long)va_arg(args, void *), 16, props);
>  	    break;
>  	case 's':
> -	    print_str(&s, va_arg(args, const char *), props);
> +	    if (nlong)
> +		print_wstring(&s, va_arg(args, const u16 *), props);
> +	    else
> +		print_str(&s, va_arg(args, const char *), props);
>  	    break;
>  	default:
>  	    addchar(&s, f);
> -- 
> 2.25.1
>

Reviewed-by: Ricardo Koller <ricarkol@google.com>
