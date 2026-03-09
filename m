Return-Path: <kvm+bounces-73351-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mM7ZMp4Qr2ldNQIAu9opvQ
	(envelope-from <kvm+bounces-73351-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 19:25:34 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 38CE023E963
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 19:25:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 639443006B76
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2026 18:25:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C666E346E7F;
	Mon,  9 Mar 2026 18:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Zd+mC9//";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZL9g5GbU"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E92C5231A3B
	for <kvm@vger.kernel.org>; Mon,  9 Mar 2026 18:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773080728; cv=none; b=jlb3Q0CSSUNhLo9VO+HB9WSpk9DsJGmAN+L7Cb5Pn/MmytsJORzjqZJEjp0rmb2p2wdQ7hKSXf2wYqOn7HIhXhNfr/lGbk+pCaAPG84tfVU2FjbqqmYVOYp0sjltuSL9yPY0vBc9b5yoQlbYNGjkYwDLwqn31bsVukj+BLcj+Wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773080728; c=relaxed/simple;
	bh=NEAST956DXI6gN+jv8DzvWfuLi+/K4PRChYv0PgsG/c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E9RFYR4qp04POGlN9n1XfwEkB86nGZdLi9WtgV660PdmwgLOy+dO5jAey4Ow7NlSPh1qGHNr42O9iBStONcDi7tpg+J/Yeu/edjyf35UWKAqRwSYXvbraZjPTKh93iHD2GJ70afYwHzR7A2Tk/gOmNk73TioabG2BxcQJx7K5KQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Zd+mC9//; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZL9g5GbU; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773080725;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=V1NoNWgfZfwg6itK+lLijN2TFmQfhew6eaFCQUiG1XI=;
	b=Zd+mC9//T8dCFxo1it0QOu8jgZLgj9gDHaNQk9A6Uwdj+1BC55Xf8ZXVOuQL1eJiS+8d6o
	DXkBAH+4zmmPT1jEbuez62sWpfpx3hdMltVe6G3j85kkW8gsqICF7Yyth3354Ie8CY7kMn
	/ixMwm+BFZ73n27PqbQESLGFp1xwmuY=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-690-MFzvWeukO5G8SJZ9HgVFBQ-1; Mon, 09 Mar 2026 14:25:24 -0400
X-MC-Unique: MFzvWeukO5G8SJZ9HgVFBQ-1
X-Mimecast-MFC-AGG-ID: MFzvWeukO5G8SJZ9HgVFBQ_1773080724
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-50900e9803aso178481461cf.2
        for <kvm@vger.kernel.org>; Mon, 09 Mar 2026 11:25:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1773080724; x=1773685524; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=V1NoNWgfZfwg6itK+lLijN2TFmQfhew6eaFCQUiG1XI=;
        b=ZL9g5GbUOiBcsRIF+uvMb5ADWdYSQCTi0NNI1iL66eem/WNrJ1RssSQe5n1X1lveAN
         WH7HziYuDPNBC5OKQUSc6Bx79hmBXlaGrTlw9f7MJhBfE3Mt273IjWwcCjyjcWVMXiqB
         DuFDeYtgYnPmYqZQm+jnagSFi+BoM1O9g+NW+GyxyLWhiUM0QH6cBJ/Ni2kpZ84Uzhl/
         /hsZllRHi7dHn2G6quSOcXKvB5+qI10qzyaPG64FVjfiRK3yFqjod0oRIgOrWTdAMkIs
         jM3kX2dYiQOH6dOQ1uSnVJ7QvkxSQZBBJhaSOfHqtG2dRePyax9sWX9v/IIiw4WsuiAr
         Xhzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773080724; x=1773685524;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=V1NoNWgfZfwg6itK+lLijN2TFmQfhew6eaFCQUiG1XI=;
        b=SaDvG9qucBvnXVmD+TIobfOSvS82F228DEck32zzDjrVRas6C0Db7FspnfS3G+X9x4
         cAvzJydBjK3Or1SZVQGfQ5OeUWVbWX/z8zIA2d60tyq/LIRftrKSZ2TNqwiG3+hC/SvQ
         jE+24HFKIK1yE+qQY45zSPGrvRfmgj15c0NjGnQvUJqhJqEIB8IHXoNs6xKpQncMraaW
         xRdG8Ffo64i01WAp9rspGIwjuoIGG75cFNpk4ta1C5DTF614Ils2voC1IW6mtU/LqeeU
         4OqKFpiQicybAVKRc5TpeCgXjvTWxc2iAcwmHJ5GeNzVUK8pIPGq7DrQvzG96hsnATny
         2ApA==
X-Forwarded-Encrypted: i=1; AJvYcCXgh7wvJoLb6VJVbtV/GXvbzzjYAMlPo1yqJJz4ic2WoaUnrU9KmLBV15uLaulQMWAbTgE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5FyBRhsd1gvt/sRkPI9a7EOknUQWnS/FRwqMoTORC0R324wJR
	uRPPhACogGnDB0k7tW+u8Rl4oqU0MNJ9c7WTn/s/6AI2Cn9uO51Kft1EWlixnvFqg6iNje563qJ
	ny3RKzqwF8Z3iIhHfLiT0Vryly7IGMM9CwuIx63fi4ftrgutk30dozg==
X-Gm-Gg: ATEYQzw+OWAHNDo9wTagvjheg1zkLiEu3r4x4GG8N05FK4NKsDHfbUjCxhdlmyosl5s
	sWYEmhtFg/W7gRUF6qV8gC4rt8JG59GGT0PKKF9U8VBkwIECs+c/xluQl2VeDkdwSpitPQd5D8Z
	02FpgKlqH9fCBxsnB99a9dUDykSJkDqicQE+90ArL6ZLogAi+wGYGw+PLOxk16CgDXeZ6qKipcA
	dYkVtAuYI4E6GdJMCd3u7bNJQIV632Z48U/i3bmhP8obJdl4K47FGB/kaAXVMrgJUgSSIPckCje
	4lPlYFruwdbQasVG4tt+fesBmYL1b6PRO1Le5Wx5i8/7s+A8ruR65dzjbmZDNLcQfZmaOpzBuzt
	7bKYsIAlP7+8OxeUofGlx9aqJPEocIncuqN6lro/Jh2rUzx+uGVqRN0dcfn/wxNr4KFIWMiT0+0
	SEG5SrDg==
X-Received: by 2002:ac8:7dc2:0:b0:509:1ad4:62f9 with SMTP id d75a77b69052e-5091ad46e9amr54083771cf.4.1773080724164;
        Mon, 09 Mar 2026 11:25:24 -0700 (PDT)
X-Received: by 2002:ac8:7dc2:0:b0:509:1ad4:62f9 with SMTP id d75a77b69052e-5091ad46e9amr54083411cf.4.1773080723642;
        Mon, 09 Mar 2026 11:25:23 -0700 (PDT)
Received: from x1.local (bras-vprn-aurron9134w-lp130-03-174-91-117-149.dsl.bell.ca. [174.91.117.149])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5092657fba3sm2429841cf.3.2026.03.09.11.25.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2026 11:25:22 -0700 (PDT)
Date: Mon, 9 Mar 2026 14:25:21 -0400
From: Peter Xu <peterx@redhat.com>
To: marcandre.lureau@redhat.com
Cc: qemu-devel@nongnu.org, Ben Chaney <bchaney@akamai.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	=?utf-8?Q?C=C3=A9dric?= Le Goater <clg@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Alex Williamson <alex@shazbot.org>, Fabiano Rosas <farosas@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	kvm@vger.kernel.org, Mark Kanda <mark.kanda@oracle.com>
Subject: Re: [PATCH v3 00/15] Make RamDiscardManager work with multiple
 sources
Message-ID: <aa8Qka5kY8zd8IGh@x1.local>
References: <20260226140001.3622334-1-marcandre.lureau@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260226140001.3622334-1-marcandre.lureau@redhat.com>
X-Rspamd-Queue-Id: 38CE023E963
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-73351-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[peterx@redhat.com,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,x1.local:mid]
X-Rspamd-Action: no action

On Thu, Feb 26, 2026 at 02:59:45PM +0100, marcandre.lureau@redhat.com wrote:
> Marc-André Lureau (15):
>   system/rba: use DIV_ROUND_UP
>   memory: drop RamDiscardListener::double_discard_supported
>   virtio-mem: use warn_report_err_once()
>   system/memory: minor doc fix
>   kvm: replace RamDicardManager by the RamBlockAttribute

If no objection, I'll queue these init five patches for 11.0.

Thanks,

-- 
Peter Xu


