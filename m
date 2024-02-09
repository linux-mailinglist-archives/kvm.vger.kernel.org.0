Return-Path: <kvm+bounces-8382-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E32B84EE69
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 01:34:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4D4D8B21839
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 00:34:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 957101859;
	Fri,  9 Feb 2024 00:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="T6bG4WVZ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Zb/JTyg1"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 383D01370;
	Fri,  9 Feb 2024 00:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707438879; cv=fail; b=diq7WXZx6cR/m6R296oeVd1fXxlMjD9x29rb2u9r9AJynfZ7RG23LdG1nvMo3Flvcyz4CLhkoYl9bHDlAH1KbsQjIO8BxnylrfhgQg10wjmvnVQSD3VWdsLrSoe8YvBNGaERPs16Oyn9RvvGGK/LabrrLEHi3+YjnRbdnL8Kmuw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707438879; c=relaxed/simple;
	bh=qK8JlZKQQdPNd4Dn2wl2Piayjokx057/B8GlaMCVhQQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=MCHJu8ORW0sBI//3F6HUa8IVmyXH8Avx1iHlycGjryuj3weW4HK0TtvdgNLV3O7du3yC/IUJ3meekrcCXt+2iV9plfpwz/I0W6as4y72cccUuPhZIY2OvKPKtB3mBiEpJA5KWeH5Q01Kc/s0hJ8knCFp1bLG4QUA8cMAFcb+ZMY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=T6bG4WVZ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Zb/JTyg1; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 418LT8nU024380;
	Fri, 9 Feb 2024 00:34:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=QDKXzmoyDTI1j4iq6xJZkbA7ELzaJE/05i0Hhd6cr1M=;
 b=T6bG4WVZYK9Jf8moHNlQbS14xfObuyX2FkdknLOcWfPM3MuxDxrNnMlK/v7VbJnXp6dc
 2av7iBupX8H5ASibDVmHCHLlT2ib495B66R7o7Tnye7gGka0sFMN0PgdotCI8VcTyqbj
 T8VTwmJ9rbmxxaio+/D19IkimjqNTifGGcbggaG1CDSStTNfA8AuzyX8KC9tJdhhJ+eh
 kjVl7Ao2MpcCenkLOJt7Kq9GmPYgzVN6RFRleYe4yhmlVor8FqEOYBhMI63Xt5wdpw3f
 Gdg1C/RH12PE2D4wEPcCKr07btL6UxkORES4oAhU1KoTCvrpCFOsGs617jHswKTakVe6 kw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3w1e1ve5c5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 09 Feb 2024 00:34:31 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 4190VlT9038437;
	Fri, 9 Feb 2024 00:34:29 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3w1bxb9hq5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 09 Feb 2024 00:34:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HRK+EDQ+uQ16XMJMb07yFn5R8ia0/qmCBgBOYoye8fLqNfxGZ3bgx+qQu+gsYq4WWTRADoYDEOSUsZV0mfgZgFA1BliU2qjr7KAzmhFr8reAAreYM7RMDAJrrwrA/O8AQEmtF7UTlvMdaJfRpALIxpVLE4O7maX4/ijQG44knXDCr4bAPsjKhQlthDDtqXfksuSmtIJsA1mwYZES5QSlXPUIKhXWyd3NmoQ6pk3noNHkw+ApGsOVdIK7wppclqOx8SV70+jK+TV6eSpTJOYYA3qPexMfLs9UAhCt4smletNNoPpyoEqYS8Z0tHqQkG/THd4/G2ZIAMgcc0CUhJZ/ZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QDKXzmoyDTI1j4iq6xJZkbA7ELzaJE/05i0Hhd6cr1M=;
 b=GcQDVVctAcWBF+mG3lX1whT+cWxyoaYmAWnj6JHjmvi3HHKYikCw1fJaYbhAH1+/q1gxA0VwvoxsRi1+GxgXG0Rvw3KVn25/ljex+6eHsBHrKdTYZ4AG961x+2HgUwgnyYxTIeybxNHfaAIur60V8TY4zxGTuTuYG/24ehY2XMqF5cR/6rl1aDQF+7k9cYB5UHasRpEtViW2vljbWYNbmbtvnT1yRIw/Q3sGly5QpPkfnBHl3IWLOXU6W7fKzuckcU4UFSX1R3ASi89gn4Gmw2Wzn52RKwxdSD+Di7speAiRsAYYV6Rh3AvWdtWHn47njXLYZOd7QALrJHFULjafGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QDKXzmoyDTI1j4iq6xJZkbA7ELzaJE/05i0Hhd6cr1M=;
 b=Zb/JTyg1hMkSO1+kk6nxf7JR1wjmVqU+w6j9eom8gNc4GKPmaexPdRZoZ/8DNR1Ru2GkkrIHrtCCB9H9pfwY5JoSmBsAyvL5a8BU7mP9RHZFr1T12wJMzC0a+5FNIyG+4XlMDniw8e74x3/NoatSu3F/nPc4TTTeIQma9coRxos=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by SA2PR10MB4715.namprd10.prod.outlook.com (2603:10b6:806:fb::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.27; Fri, 9 Feb
 2024 00:34:28 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a1c5:b1ad:2955:e7a6]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a1c5:b1ad:2955:e7a6%5]) with mapi id 15.20.7249.038; Fri, 9 Feb 2024
 00:34:28 +0000
Message-ID: <3921d23a-100d-a696-d48a-116e0e702e3f@oracle.com>
Date: Thu, 8 Feb 2024 16:34:26 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH] KVM: x86: make KVM_REQ_NMI request iff NMI pending for
 vcpu
To: Sean Christopherson <seanjc@google.com>
Cc: Prasad Pandit <ppandit@redhat.com>, Prasad Pandit
 <pjp@fedoraproject.org>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20240103075343.549293-1-ppandit@redhat.com>
 <8fe554e5-e76e-9a0a-548d-bdac3b6b2b60@oracle.com>
 <ZcKdhuE2yNednYPD@google.com>
Content-Language: en-US
From: Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <ZcKdhuE2yNednYPD@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR06CA0054.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::31) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB2663:EE_|SA2PR10MB4715:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b880765-4b44-4187-2e5c-08dc2906dfa8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	4I14ZW8607LNMpGRtWJoJcUwT4WEwyLC0iUSSAKf0DMBdBoAfXbHIdLi7fQSaTFr6E9DKTt9j3xO1R28RcGCpa6+A/RPSCPp2FlRchh2gTzL+y04P1CiFG7+UuSkctABRtDNvC4ojhOVYvyDYAeXwsDxMF8C7kRxjj1XL8IxxtjFi9c5+COCpO53gJX0iw6nHDThTgSb6JBMbIOEMsxaSr4a11FDjB4g2B8ladHaGO3XHBUdamfKaDlvYMbzaLqLt9Bm5lvEG4FCQFqEoemHVzZ4bTn0NF/eQGXLWiYUIQqwV8SH80ikcSXMDCLIBZhiRqRqah96ALY7rteM4mH4zqOfSz9OuCO5J3ZRMZGLuXmA0YlLPMQrm58cyV6jeknRd0MXjAOF7HyyU+AkzgYsCB1jxMuCLBDRkwZHg0FCoDnKdjvOHaSQthRk6vt8DhV/jpSJkHEa0YQAKFQSX/hfj5pdL6PZ0NHoUioJCQ2ZPnyyXnGc35gauDXu5FaJcf27wcjqNjMZcZaaCWYQ3EbiiwxNbvWjwQnaH4H21vCmeF0=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(346002)(376002)(39860400002)(396003)(366004)(230922051799003)(64100799003)(186009)(451199024)(1800799012)(6506007)(53546011)(6512007)(6486002)(966005)(478600001)(66899024)(83380400001)(26005)(2616005)(5660300002)(44832011)(2906002)(66476007)(54906003)(6916009)(316002)(66556008)(66946007)(8936002)(8676002)(4326008)(36756003)(38100700002)(31696002)(86362001)(41300700001)(31686004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?cXBiL2NvdE81Tnl5N3ZxRHlJblRUU00xVlRXZmg3NmdSWVp3bHdsc1AxUTRT?=
 =?utf-8?B?MGpybTB3TDlHcTRXMUwvWmpyWjF5UVJPL1ZZdVloYmo3WGt2ZXBDaEoxMUZl?=
 =?utf-8?B?MU9KSkVYakhXZXN2VVR4OFNNd0JTMG5WNy9RM2xldFBDSVVEdTgvaHpkUGl2?=
 =?utf-8?B?QW1BcHZZWG5wM3poODZta0g1d0JUQ3hkblJnbCtpRGtJcW82VDFLaEJ1VEtG?=
 =?utf-8?B?UkJtWC9uUi9qN2JkV0g4UFVMbnVxMzdKL0RmRWF3cmxtSlRISTc0RjF4aEIx?=
 =?utf-8?B?NlJ3N2F6c1ZLMkhLVzF4cCtySDhqamRydUoza1EwMS92KzNuM1pFdkxYQUoz?=
 =?utf-8?B?VWZ4WkZKNHVnWkNlN1VHakdPZy9PR0pHL1hzdmRZWjhpbGpyZDRkRTE3a3dP?=
 =?utf-8?B?aXExQmxkczdybXdZTzNDcEs2VkpXMWtyLzFrelQzT0pjTk9HbmVsblRabmFl?=
 =?utf-8?B?RXl6WDA1d2NROEJYZ1B6OGVYZUMvY2R2SDk5U3QzajhmTlZXVitDTUtUZVJH?=
 =?utf-8?B?Q3pYdHlheDh5THJheFpvTVFFa0gza3BFWnpWQjBWMmRqY2x5MmErdmYvaGtV?=
 =?utf-8?B?cFFmdWZRMFBXU1RmMlRpa0RJQ2g4UkRNbjJQK2g0Z1pjYlU4REZLeWUzNlQv?=
 =?utf-8?B?eDNSWEVxWCs2VWU1ZXdQb0NuWFJUZCtKNHRVTk5wckFOa2I3bnh0UGRLYnds?=
 =?utf-8?B?Z0ZQV2dZRW9SNHVXK3EzTmVyRjI0MFBQbGxmYURIdDBNV3U3ZTcrL3dkaG1U?=
 =?utf-8?B?ZUd2bkNwSUd5Tk1JWlBjbDFuV1R3cjMwa25NdUhsUENzR2Z1eERpd25Tdys1?=
 =?utf-8?B?MWM5RnhBeGVaNGtLR2xRdHcxOFFKeXRJbGxNN1lXYVQrNVIxSkE0ZE1sRjJW?=
 =?utf-8?B?V1o4a1BWd1R5WU92RDNyQitaOHhLVXY5OTlRd2tNNjRvTE54S1Z2ZElORC85?=
 =?utf-8?B?ZEZkTmloeEhzV3RzZTNiWHgvaE5lK3hQak8yQWd4bGE0ZzlYcFZHZFhMWW9P?=
 =?utf-8?B?ajlRMXVGU1FlZnF2S2NFdW1Eb0dlSk9SbWNYb3FXQmNrYjBRbkVlclNQaUx0?=
 =?utf-8?B?bkxFd3hWd0lkQnNOMThCRmUyMVlSY0g5SEhlY3RpZlZ0TENCMnRrc3hBTElL?=
 =?utf-8?B?RVRleHQvZzNhajBySitUWkxTNGN4TmJacUJNemlXb0pxdGQwR1pVOCtzRVdF?=
 =?utf-8?B?VTRkTk5pR0gzZXBGNGlURk9BbG5UV3NOTXI5NVdlWW40ak9MQ1NsajdzNGl4?=
 =?utf-8?B?UHh2d1hJdXVwcnhhZ0x6U1R4eXNkTjJPMENFZTgrSEM4ZG43T1hyeUxFZDA4?=
 =?utf-8?B?WmhINHEzd3RjUUs3aG9sR1lnMXR2WmU1Y3JtNnNtRi8rVTc3TWpPYTVmUEtT?=
 =?utf-8?B?N0U4Z1JLTGFobStsdlQ2WlFkVkt4ZnJxNzlxd1dHUjd6UzZKL0tVUDJOSi9p?=
 =?utf-8?B?K1R1N093alZwdUZMYmRNamVvdDFzTXRickRyTWJpY3pKRGVMZ3RGUzhPeHpr?=
 =?utf-8?B?MGtvcFl0ZnorNjZiaUZnNC80N3llRXB5YkN2MU5zTFJIM1BGdmdCSkZHQ0V5?=
 =?utf-8?B?OEJOWHN6WjVmazBRcVhRRmxHK1RtcHBFdU42VGNzTUVlUHdxUHpBT08zUlZZ?=
 =?utf-8?B?WUxHeitYeStHKzE4N1FPNjhubTlFSlI4ekhDaEViZnpjWkdQV0szcytBVHhI?=
 =?utf-8?B?TlZLQVhRMDFUOVk0bEw5Vk9RalQ2VGdyN3RHNEJvMVkvMk1LbHFTUi9jdlhx?=
 =?utf-8?B?SHVXcUZNa2hXVjhURmtVdXR3cmVFMWRPdVNpYjdhMjNDNFV5dWgxcFZoYzh1?=
 =?utf-8?B?WW1pQnp5ak8vaC9yTkcxT1RJeHRlTXU2cHdaOTFzMlZsdFZEU296Q2NSSWlQ?=
 =?utf-8?B?elFPMTdEVXNvSzhOUllWUTVha0NiaytROFBlN05CVDVXU3BHbmc4R2lRU1cy?=
 =?utf-8?B?bG1RRDlWL05OV0MzaDZFekV2VTdjR1U0dFhDOGdEU1B3SFVselBKTlc3c2xq?=
 =?utf-8?B?aFpWOHh6eDV1Q05TNFFWU0ZFd3ZKZ2J4ZkRucDFUMXdpUHBnL0h4TCtaRXhP?=
 =?utf-8?B?TzU3OHJZQzJtMUx4VlF6YkhLL1dPZkN1K01xRERHMWJoYkxQRzViWUd1ZnZo?=
 =?utf-8?Q?cenbTW2kWeIZXC94Pj30p4VpT?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	KbU09WQMv1tuhkl5lOTDpW0lyxW0hdn2t6Dshr7Tngx5KBVlFxEvm2RVLeQQjQ5+Sz0E9RNskl/sXExWXtOHvNM9H6rPtKF5lxFg36+0aMVBhZzXKiWZ1mTROexfzMr3rSwc+F/Y8h8r6PWlDZyB35pO0bqKkfqsW7G4uoLDwWZFIE93GajA4hOZqtnYhNrBUSoTkUB729+7fjrCUsVoKFhmdcJhqTOQMeojvBcAk4V99nJRx8jwtjI4tbtggLN6XZ7Fv6a6jYaOeBF6Zcn1MpG1H2nqxfi8xf8qeDhcPtvSFk6kdlZaR4royDmHrmqPL59QXwHSiALcXBQ3iNaR9nWQb5mwIC5f/KWm9s9vkiRKkKNXu2mRvUi+1O+pIrh5dZGGqe4I9xUKYVccGsWUhex0Rkn6YWE94QYQgR28nYOj5Jdn+PRypun6DHezSmQcz6LWXHg7bNN/OdzYm7oJwB4tOdgmNf/vy2wjBPESwUf3a4Ib5yqB0WstnF3md9E3+1ZlIzzVM/ZEawa3XExLBBBsep4WPfeaxITaHGgXzWYULzHwrAiafM5VLq//zHWcF+C2ZlA08LHse02jeJY7XdyJcZkWYbfLUDPivtj1U7s=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b880765-4b44-4187-2e5c-08dc2906dfa8
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2024 00:34:28.0412
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0WWOyWQTPoer3eEO4i0T64NFntombbxOojl20Xll2+wlp1/CPfdBiD0juonRKYkedupAp7hqgFdKPviJq2LDFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4715
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-08_13,2024-02-08_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0
 mlxlogscore=990 bulkscore=0 mlxscore=0 phishscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402090001
X-Proofpoint-GUID: xMTl54meysQVxT5CO5xmY57fnqBr9-Aw
X-Proofpoint-ORIG-GUID: xMTl54meysQVxT5CO5xmY57fnqBr9-Aw



On 2/6/24 12:58, Sean Christopherson wrote:
> On Tue, Feb 06, 2024, Dongli Zhang wrote:
>> Hi Prasad,
>>
>> On 1/2/24 23:53, Prasad Pandit wrote:
>>> From: Prasad Pandit <pjp@fedoraproject.org>
>>>
>>> kvm_vcpu_ioctl_x86_set_vcpu_events() routine makes 'KVM_REQ_NMI'
>>> request for a vcpu even when its 'events->nmi.pending' is zero.
>>> Ex:
>>>     qemu_thread_start
>>>      kvm_vcpu_thread_fn
>>>       qemu_wait_io_event
>>>        qemu_wait_io_event_common
>>>         process_queued_cpu_work
>>>          do_kvm_cpu_synchronize_post_init/_reset
>>>           kvm_arch_put_registers
>>>            kvm_put_vcpu_events (cpu, level=[2|3])
>>>
>>> This leads vCPU threads in QEMU to constantly acquire & release the
>>> global mutex lock, delaying the guest boot due to lock contention.
>>
>> Would you mind sharing where and how the lock contention is at QEMU space? That
>> is, how the QEMU mutex lock is impacted by KVM KVM_REQ_NMI?
>>
>> Or you meant line 3031 at QEMU side?
> 
> Yeah, something like that.  Details in this thread.
> 
> https://urldefense.com/v3/__https://lore.kernel.org/all/CAE8KmOyffXD4k69vRAFwesaqrBGzFY3i*kefbkHcQf4=jNYzOA@mail.gmail.com__;Kw!!ACWV5N9M2RV99hQ!N61g2QXuC5B5RpVNBowgKUXjHzX4vp0lCXuton3fKVRbzBuXaVtJgePu0ddSf3EB9EEQORTmwop4vD5KrQ$ 

Thank you very much for pointing to the discussion. I should have found them :)

Here is my understanding.

1. During the VM creation, the mp_state of AP (non-BSP) is always
KVM_MP_STATE_UNINITIALIZED, until INIT/SIPI.

2. Ideally, AP should block at below. That is, line 3775 is always false.

3760 bool kvm_vcpu_block(struct kvm_vcpu *vcpu)
3761 {
3762         struct rcuwait *wait = kvm_arch_vcpu_get_wait(vcpu);
3763         bool waited = false;
3764
3765         vcpu->stat.generic.blocking = 1;
3766
3767         preempt_disable();
3768         kvm_arch_vcpu_blocking(vcpu);
3769         prepare_to_rcuwait(wait);
3770         preempt_enable();
3771
3772         for (;;) {
3773                 set_current_state(TASK_INTERRUPTIBLE);
3774
3775                 if (kvm_vcpu_check_block(vcpu) < 0)
3776                         break;
3777
3778                 waited = true;
3779                 schedule();
3780         }

3. Unfortunately, the issue may set KVM_REQ_NMI for AP.

4. This leads to the kvm_vcpu_check_block() to return.

kvm_arch_vcpu_ioctl_run()
-> kvm_vcpu_block()
   -> kvm_vcpu_check_block()
      -> kvm_arch_vcpu_runnable()
         -> kvm_vcpu_has_events()
            -> kvm_test_request(KVM_REQ_NMI, vcpu)


5. The kvm_arch_vcpu_ioctl_run() returns to QEMU with -EAGAIN.

6. The QEMU side is not able to handle -EAGAIN, but to goto line 2984 to return.

It acquires the global mutex at line 2976 (release before entering into guest
again). The KVM_REQ_NMI is never cleared until INIT/SIPI.


2808 int kvm_cpu_exec(CPUState *cpu)
2809 {
... ...
2868         if (run_ret < 0) {
2869             if (run_ret == -EINTR || run_ret == -EAGAIN) {
2870                 trace_kvm_io_window_exit();
2871                 kvm_eat_signals(cpu);
2872                 ret = EXCP_INTERRUPT;
2873                 break;
2874             }
... ...
2973     } while (ret == 0);
2974
2975     cpu_exec_end(cpu);
2976     bql_lock();
2977
2978     if (ret < 0) {
2979         cpu_dump_state(cpu, stderr, CPU_DUMP_CODE);
2980         vm_stop(RUN_STATE_INTERNAL_ERROR);
2981     }
2982
2983     qatomic_set(&cpu->exit_request, 0);
2984     return ret;
2985 }


7. The QEMU AP vCPU thread enters into KVM_RUN again. Same flow as step 4, goto
step 4, again and again.

The lock has been frequently acquired/released. The vCPU 0 is unhappy with it,
especially when the number of APs is large!

I guess it is not an issue after VM reboot (without QEMU instance re-creation
because the mpstate is not KVM_MP_STATE_UNINITIALIZED any longer).


Thank you very much!

Dongli Zhang

> 
>> 2858 int kvm_cpu_exec(CPUState *cpu)
>> 2859 {
>> 2860     struct kvm_run *run = cpu->kvm_run;
>> 2861     int ret, run_ret;
>> ... ...
>> 3023         default:
>> 3024             DPRINTF("kvm_arch_handle_exit\n");
>> 3025             ret = kvm_arch_handle_exit(cpu, run);
>> 3026             break;
>> 3027         }
>> 3028     } while (ret == 0);
>> 3029
>> 3030     cpu_exec_end(cpu);
>> 3031     qemu_mutex_lock_iothread();
>> 3032
>> 3033     if (ret < 0) {
>> 3034         cpu_dump_state(cpu, stderr, CPU_DUMP_CODE);
>> 3035         vm_stop(RUN_STATE_INTERNAL_ERROR);
>> 3036     }
>> 3037
>> 3038     qatomic_set(&cpu->exit_request, 0);
>> 3039     return ret;
>> 3040 }

