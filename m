Return-Path: <kvm+bounces-779-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A05337E28D4
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 16:35:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2F446B20F42
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 15:35:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B416E28E20;
	Mon,  6 Nov 2023 15:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EbUg5E0M"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41BC428E0F
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 15:35:33 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36C25B8
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 07:35:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699284931;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
	b=EbUg5E0MGmMQnfqOMLGavwQ3MABB56ByrWv8cwoN8Lzxnq5NLBMWlt1luSPWhztTmovuD0
	ca8Zea4XTRHLPYggZOy3Citz1wQ+M+pGu5mT5YihSPemhg38ZdmV0MlUf1F4+QDnCw3OSf
	mfjG0dKNJFaeBYv41LF3zabpmQUWcfQ=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-115-Vj2pGwTuPcuAJZx0W02IpA-1; Mon, 06 Nov 2023 10:35:29 -0500
X-MC-Unique: Vj2pGwTuPcuAJZx0W02IpA-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-32fa25668acso2332061f8f.1
        for <kvm@vger.kernel.org>; Mon, 06 Nov 2023 07:35:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699284928; x=1699889728;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
        b=R1QRMukU6ptVwSWDAgXWZ450z/QA288Znb/wY+OcbG4TWwYssSp/T8Xu+LPFdtItPD
         ZIOSUimd4VA/8WbPxjS+k2LP7UOS/nxjsjHqXo0Ng5BJCtb42BGLWc69/IyaJj/Q0vmK
         p6XogsxHmdivgzO9EOakMa0+ER0MGkGsxRnIgXojuwUtAna+2OR2ZqerZVLESlAw8bAv
         ybufG+GqL3JMYDJL2oqInH4P0OL7hU8CXgnXyP2xE3kTzOUSSSwNNivkVnsUC9xor9lI
         M3dUPYGnjQrBxLfjgYsbD8bLuO8ud7CkedeR/pua+R1+DfwH0l0EX6J/YTwAefZ6/6VO
         A/VA==
X-Gm-Message-State: AOJu0YwYHjxr3j0+cBwPA920sTmov2s0Atd07Ee80yZdbq0MqzwaW/Qe
	flytEppDZJwB36tLxJwFb3VYyTdfgQ7sI6YrNzaCsFmu0v/8JnKh67CxfcCEhUQ4RokyXS95IeU
	zfdcVwJP5j3Db
X-Received: by 2002:adf:e544:0:b0:32d:82b4:1957 with SMTP id z4-20020adfe544000000b0032d82b41957mr22964694wrm.40.1699284928156;
        Mon, 06 Nov 2023 07:35:28 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGB+hvEtcEYbw7nHXb6mTXOGKcehrK2MMN0/X/aJawX2ZrpkQHnPCU04aA65se1mhd/If+2hQ==
X-Received: by 2002:adf:e544:0:b0:32d:82b4:1957 with SMTP id z4-20020adfe544000000b0032d82b41957mr22964679wrm.40.1699284927791;
        Mon, 06 Nov 2023 07:35:27 -0800 (PST)
Received: from [192.168.10.118] ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id m1-20020a056000180100b0031980783d78sm9737093wrh.54.2023.11.06.07.35.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Nov 2023 07:35:27 -0800 (PST)
From: Paolo Bonzini <pbonzini@redhat.com>
To: Daan De Meyer <daan.j.demeyer@gmail.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org
Subject: Re: [PATCH] Add class property to configure KVM device node to use
Date: Mon,  6 Nov 2023 16:35:25 +0100
Message-ID: <20231106153525.417950-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231021134015.1119597-1-daan.j.demeyer@gmail.com>
References: 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Queued, thanks.

Paolo


