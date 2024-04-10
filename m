Return-Path: <kvm+bounces-14062-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F001C89E7DB
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 03:36:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AC6891C20C03
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 01:36:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2ECB1FAA;
	Wed, 10 Apr 2024 01:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RC7xUIBK";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="bVY7pVHG"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFB9510E3;
	Wed, 10 Apr 2024 01:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712712999; cv=fail; b=cre0aRiZYN6XoWyJfrw8Tp9BGrmZohB8HHJhjqch+dKkLsSPc/7WJX6GNr8GT0oR6hwW/8YwZRwr9yymQtrRoZ/OM9DsRUQ7ck8Cgo+9BHy1vgGBimQfJOZLAqjw0KYm/REsULsbmt48oN/LDoHcLhigiffGk9YtJxujK1slDi0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712712999; c=relaxed/simple;
	bh=NZskhTjtSSefmv+jvCSo1YhumTT+LrotUSWzA8j3U5Q=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=m2blLV/iGtGH4TkO3AoA7U026tKN0V7s/OaJ8h8j3N8qJ5odIeipW94d1wYxjjdEmzB/Q7Fl1YvhfKnsWSyzxeXEsHrZit5HBu/SSy4vi060urB6xSOa4VgVh1FuWAO2NbxRy2F+2NbPONnMQKOJpy9oR9OidvmrsGLASuS+qMU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=RC7xUIBK; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=bVY7pVHG; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 439NEvH3001510;
	Wed, 10 Apr 2024 01:36:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=nvnx4Ps3AHBOrCGfDPMEVhLV2HW5aqitgF5IjtQwNpc=;
 b=RC7xUIBKpeSS7kCvOU+RsCwxDm7h2CxT2jSSurmyrFKcWnrWAZJEoJObGUzuDqQ8b5iD
 i5uvNgC5F9YIsk4mQwYV7qNaDY9aeLbjLAj7MaSRSLAiZgLr9srNH05VTXAN+DDxRYuL
 HBkliNLhSInaXTXqawXogmTFtnHJabX5eIUmfcWVeXEJ3cs8nGUYPKMoX0rOy7BG8wdd
 rzv7icODqPH21hVIUUea0miiYjbkWvSsHFtNqSi3ugXlw8ZVJ3e18AHd1EwAQu9sFoob
 LTWmX05DF5tWTPU0QDLWX3FfTHcC0oaq/4INjBVx4aFzbd4IIzxOE6DHHUjxruKAFthu tw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xaxxve97m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Apr 2024 01:36:24 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 43A004Um007862;
	Wed, 10 Apr 2024 01:36:24 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xavu7g3sg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Apr 2024 01:36:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VKM6Ix+KLuEi99BQh1vag4ZHKXe9tiBSs3BIQCBYPsTbuMiqGLX9HKL2rTJROUTu730unD+pXWkNdFm+Wcknc29KhZNCmuZO9QcZGXOIEwWxf9fHSvwZBEaG+wez0zfxfaPiGcwj0bvg6AqN0cvyRyV/bVn65FUjo9xMpkhoDbuUqrX/ma7W2dDGG8FgxP9jZU7nkIRB/relMdRgd08gZLJ5dfpT8RJRIcr0n2DCyKSKduWzWHcvOxkp6NIdvI4dQn7XmlGHAIV6KJaCE/1KqgHe7ULDQXZHRB3MpdISN1+s18toAhxgGTkneVUxq6GtpE5ys/B+gh7bTCHbcqQTeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nvnx4Ps3AHBOrCGfDPMEVhLV2HW5aqitgF5IjtQwNpc=;
 b=Urdc+vPx2ZtJqhcobhp4v2OKp4b36zKkKm9EWMe8wqB0JRpHYfsCTdQsH4CdMflxAXi5QShosRmCCcYnwwcFIPSynAGft2Z8WyCZoFkB+gXOGxvl4lmSgcJIe4OgBlXeKOJVCCnjKFW8lSUzX5BhbYRUtbeiFDC2IiprMpLMg6fMjpQQQ6FGUz+3VRBkCLO+qooG7Zcv/FEuMHfFv5PRrH30ASXTIi1neLLC6X/vlEeT6ne7aWQ8nUrq1SBZlxwX0/8r1YTXBcWbpXZuczC0InL1M4YI9Pdt1/llHPZ9sZRtRp8q8bT+vwIYzhaWbC1QVXyFuXecrj922OeBv2znHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nvnx4Ps3AHBOrCGfDPMEVhLV2HW5aqitgF5IjtQwNpc=;
 b=bVY7pVHGcOUd0BVUX7TBjoyL8uj6mSlWGWxBGAQCInyP3H5YdfIYah3hLWrrgIzp3nhD0KxZjWKwTcXMaMZ4AdATUZG6/6stTNZAHPWPVJt2DIAheNMHbVpDDtApn7pAkryBv9RYvi/vYz+0Qk1hprQNYKXqkMTPVPubjXUpQcU=
Received: from DS7PR10MB5280.namprd10.prod.outlook.com (2603:10b6:5:3a7::5) by
 DS7PR10MB4927.namprd10.prod.outlook.com (2603:10b6:5:3a2::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7409.55; Wed, 10 Apr 2024 01:36:22 +0000
Received: from DS7PR10MB5280.namprd10.prod.outlook.com
 ([fe80::c7cc:f6b7:386e:fd5d]) by DS7PR10MB5280.namprd10.prod.outlook.com
 ([fe80::c7cc:f6b7:386e:fd5d%6]) with mapi id 15.20.7409.042; Wed, 10 Apr 2024
 01:36:22 +0000
Message-ID: <11081a6a-b61e-4b10-9792-55c8731c2897@oracle.com>
Date: Tue, 9 Apr 2024 21:36:19 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 0/3] Export APICv-related state via binary stats interface
To: Vasant Hegde <vashegde@amd.com>, kvm@vger.kernel.org
Cc: seanjc@google.com, pbonzini@redhat.com, linux-kernel@vger.kernel.org,
        joao.m.martins@oracle.com, boris.ostrovsky@oracle.com,
        mark.kanda@oracle.com, suravee.suthikulpanit@amd.com,
        mlevitsk@redhat.com
References: <20240215160136.1256084-1-alejandro.j.jimenez@oracle.com>
 <19f634de-7d72-4abc-87ff-599d22e310bd@amd.com>
Content-Language: en-US
From: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
In-Reply-To: <19f634de-7d72-4abc-87ff-599d22e310bd@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL1PR13CA0441.namprd13.prod.outlook.com
 (2603:10b6:208:2c3::26) To DS7PR10MB5280.namprd10.prod.outlook.com
 (2603:10b6:5:3a7::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5280:EE_|DS7PR10MB4927:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	1Ge0hlB0/N2UxYw9P02KVFAekIAnJ4sbYrlHVY9B6cac+yeyF1xiPHwEceLbeVJu7t/cshKSXF0QWyAqkM8nHkDz3dMgVA9ToIWoMkRSjL0z9+LN0OfP60kKNg638zCXY7VB/eudtpYsnRNrjythFZVTvbSi7TuzIZ7c/33fqhgx2x+RsHEnc5g996lx9l1mkDJeSt6MWvAsi5TYwfC8Nou+rJVZWt0XzmpBsDZi2da7BLO0mRDB80zWOxmSjmYx3fRSV6mjOlUwKaMCQT5iL/lQcvVHZPwRCDehge7fCiuivxu4M5b7iOf/Ag3HRnJpvYOy4+euAYl/xJaGqZPBfz31dn1MPN0572Z0w3cBQYUYIvBAHx6xLw76auUPHwJJpqBPe+N9Cyllc/Cp3gZOyy8w0TJwXytCyduR5fYfUQ3tw1lNUo9v7c2Qlj9eBVgv9q3hyghuSRVAhTYYjbbtwfIvIUFoFyzjLyUt1AsCGs1NUYXFODN5cVYJoHSHRNLzKHAWPNKD7BxT3W02yubLazUrWlgzDL/gu2B4EFIimY7WgKmL3BljMR8VQMPTc20A50Hm0ipDVNn2lCQ7DvVw1a+FcdlcjTiXuh/EDlEVx+P5CcZthVxpm8qLagBRsIAWvtHI9VTwqheUWzvAafncFI+AnBxkbwVVgrNZtoEXdII=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5280.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?NXpmNm1UNU9CL2REZ0VsTVlYM2pxM3FwY1YranhtMWpjdytsVUJMWnBWWHls?=
 =?utf-8?B?QmkxU3RSVGtmaUFBc2tYMkxLSlRTVFR0cHR3cllNRVBwbW5oeWpzVUtqNXl0?=
 =?utf-8?B?YlhkTGtyT295UlZQYmZIckVrbitUcTN3VWdlMFdreE55L1BTWjNxVjZ5T1RC?=
 =?utf-8?B?UGJaaWowMjdiZElDeFdEdDNNQjhwVEZQbnFFZXpzc3dQY2NXNGRLRForcUxC?=
 =?utf-8?B?OXl5ZEpQZ2dOeTRqYnZ4ZWg3NEdMQ0ZKaE00ZWdZeTZoVVpNM2IxSzhmeTZp?=
 =?utf-8?B?REd0TjNMWUVvZUdzWDFsMXh0T2hJTStManNXb1hnWjhZZzBuL21UV29xZTRO?=
 =?utf-8?B?Q2RtQ214ZEluSm5uT0RmRkg0NDFyNjdkeFA4NmlJaCtoemt0Mk4weVFtVWxE?=
 =?utf-8?B?OEdVdDV1b1lVOEZFOFJtbS8walArWVZMWlBPKytJOTNnTGl4L205QVlJVm9C?=
 =?utf-8?B?ckFZcm9sS2RwUEtsMEJYUHVRZVFsdVN0S0pBTGFlZ2dqc0xFWVN6TkdhdmZi?=
 =?utf-8?B?Z1VremM1VDEzMFlUTlZnSW9VNVk2Rko5eUg2Y0JZcC9OQXIvbkErMWUxcXNS?=
 =?utf-8?B?TFNRWVZPVHhBNnBJT2xaQUpsVXZhSC9YNDU2YjZqVllZL3hSRmUyZU94aU1Z?=
 =?utf-8?B?TUJJNE5kRUVhZGl5ZWlOVlBlbTZRR0NFTmt6N0dLS0d4SXNuSGVjOFgzc2pM?=
 =?utf-8?B?WmtkcXoyUFRIWVExQTk3a3Y0QTVxMGpCcXdLQTNqVlY1eXgxRVd6UlNjUTk3?=
 =?utf-8?B?b1NzR2hHT1ZXNHVOUDJiQnNDZHExV3l1MXhkUExZQ1M4b2YrUUx3OCtEZjF1?=
 =?utf-8?B?MDBFY1ZsdmR5ODk5ZkNWdUNXOTduU1VkakFxM2Z1aXpwWmRZTjVqQm1nZDVK?=
 =?utf-8?B?R2xPQ0l3OWw3WEpHSUJNMjFuV1lzbDl0YlFONTNrb1VIbUpnZ2RYYXNKdW81?=
 =?utf-8?B?eEhuR2RyN3RMQXVLSXlJaUFZNXE4VmhOMWplWmw5UjUyajBYSVZEbmlNL0Fi?=
 =?utf-8?B?R1RkRkpiNlZ1Z09KWDBhNURGQUZxcm00NlFETmhyc2ZvM0sxN3FoeGJTZmRW?=
 =?utf-8?B?TFpVV0hJYzFEdzhOY29rWjBKS3pnbUNIUVJYeUpaNC9xNzRxWU91WlpGNUpZ?=
 =?utf-8?B?cUxxWi9MM3pJTEY4Nkx2cngwSFFWSWxUZU1aZWlzSTRJRzd4aW1kS1VvVWZL?=
 =?utf-8?B?dkRZR01PVXlQanpnaDNYUHZKZFY5NWhaRDRSbDBaY29PekE2UnJlQXlON1la?=
 =?utf-8?B?R3k5RFQyNWRkRUc3K3hQclRQLzdmVHArWWR3S0RHRzFxT1dweXgxTTJEbTQ5?=
 =?utf-8?B?OGtIMnJNYnI4ckRWTDF2ajN4Vng5UXZCS0JiVnB3UnkzTVdLQ0plSHd5UE45?=
 =?utf-8?B?dnlaZ1B1SjcrNlpGQnZOYkpCaGE4Vi9SdUc3endTdDlKSlRaSWF0QXVZaHVK?=
 =?utf-8?B?ZWdzbmlMQzkxRnZIQW9MZGVLaC9JRlNIUTU3bldseU4wTStWR29KY0ozMDJx?=
 =?utf-8?B?QlNOUGdIaTF1MnFzUlI3dmJuMkpUdGdla3pQY0dDZTdHakVMZDN2V3R5OFZR?=
 =?utf-8?B?KzVLUWpkSUtKcWJTeEpPN0dWaUFST3dUbnd0Zi92RUJTTVNUa0Y4OFRDUXJ2?=
 =?utf-8?B?NlhRRVVJY0FvR0U3ZzBabkNDbWxiLzdDTnkzR1g4WGl3TGI3MXVWMEFodzFw?=
 =?utf-8?B?UTBjcU4yWlhKdzIxQnE1WWNnY08reWQxL3lIMTRCRXBQZTA2azRwcUFEQXZX?=
 =?utf-8?B?Z2k2ZVF5aG1LeUFaNGFZZlp3UUFocVloUXBFeVRBS2d1UWtHSDBtRW5uZk5J?=
 =?utf-8?B?bGQwdTA5QTdVM0crSnZDaks0c015UDl5bGhTckpkanU0VHN2Z3FSeXQwWmFi?=
 =?utf-8?B?T044cmdDckM1ZUZwYXRyVWlwVWhua1M2M2ZnK0Q1L1AwZnc5aENJaFZTOUY4?=
 =?utf-8?B?b2dUQS84b1Y2cjd1ZTg1RkxWZk53anM5WlFFSGpaL1VjejV0cXJrSGFwdjIr?=
 =?utf-8?B?aEpOWDl6SHQ2MUVKWnAxZ2ZZRzJZWGhGZVl0SVZwczkyY3NZc0R0QlZSRGRG?=
 =?utf-8?B?WWRIY0VPOUtMNlUwVTRtb3RTMW12TWNYd2hsSUZGaVoyeCsyZnJvaUwwMHY0?=
 =?utf-8?B?amQ0SVlyT00xZFNNM2E2cFVqZGpVL1ZxWUpVWGpCaTA3SWRQbFRXcWZML2ZR?=
 =?utf-8?B?OVE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	4KFS/4dwGVDq+oxlH1fECyrdfkM1cJ2xVhMhyxwuSml4OHxiqGvPFcyG2RyLtksOkSCWV2QOELhDrb09uh3vPQjpX5iihk/BmzTIYK8/+xyw6yeEiXcsVH4zWK3ycY6beR4RrwFIA/qGJ0TCxnKSAConoaj0Zc9NhsDqKSwsXRkqpJfi+c6YXxWl7FZ9MXhbrmiNHoZbpctJvJuyLL+G4Zl0A7A1Ty7Uy9WSxBhVyURbmxX6+H/frdQIhuhbb7/NccZqw4cI+RMHxsLGYAnst/Ab8pJceW2oAUHO3S84zfya41f9JkihMwGdCHWYj2+GNKVzMm28S5tt/I8Y4QxZ5zSm9npeb8kRaRpBeRmTLHZoLsJ6gWQj9WwsjAafZjkC3iKZZUWnpiwH1+VVXA9IWexgqpEv4sjWQMC+MUmBmCAsllboWPmUT2djeXYqOXNF8TcfO2kJbPHorhgfstMOpQRac8zH60oDwqpgkT9DczHG82RaAJfDo3c7QDWI9j3rnoOn7iyjquCV1wk5B4+wSPFx0pZJagRI0xxYoVbS7f+cRjt3Z/1RyDoXDXdf7+9emEm318JwyGPiBxQ4LPmHwW1412YVZwQvA2i70BxHVJI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b18088b3-a1ca-4ed7-1423-08dc58fea079
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5280.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2024 01:36:22.0050
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VCjtgtewuc8egYl8+Ccswu877olcga4UVy4nHHra4m54r+aMjMBWBqOl2QBdvfqGf4/VDf1wPLxcZddIgkZSMdT12zyZm5iC/r4GQfNSYSM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4927
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-09_12,2024-04-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 adultscore=0 phishscore=0 bulkscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404100009
X-Proofpoint-ORIG-GUID: QZ8ZGbj1-yvLiqRUxNTQIXnXe4X-aFc6
X-Proofpoint-GUID: QZ8ZGbj1-yvLiqRUxNTQIXnXe4X-aFc6



On 4/9/24 01:09, Vasant Hegde wrote:
> Hi Alejadnro,
> 
> On 2/15/2024 9:31 PM, Alejandro Jimenez wrote:
>> The goal of this RFC is to agree on a mechanism for querying the state (and
>> related stats) of APICv/AVIC. I clearly have an AVIC bias when approaching this
>> topic since that is the side that I have mostly looked at, and has the greater
>> number of possible inhibits, but I believe the argument applies for both
>> vendor's technologies.
>>
>> Currently, a user or monitoring app trying to determine if APICv is actually
>> being used needs implementation-specific knowlegde in order to look for specific
>> types of #VMEXIT (i.e. AVIC_INCOMPLETE_IPI/AVIC_NOACCEL), checking GALog events
>> by watching /proc/interrupts for AMD-Vi*-GA, etc. There are existing tracepoints
>> (e.g. kvm_apicv_accept_irq, kvm_avic_ga_log) that make this task easier, but
>> tracefs is not viable in some scenarios. Adding kvm debugfs entries has similar
>> downsides. Suravee has previously proposed a new IOCTL interface[0] to expose
>> this information, but there has not been any development in that direction.
>> Sean has mentioned a preference for using BPF to extract info from the current
>> tracepoints, which would require reworking existing structs to access some
>> desired data, but as far as I know there isn't any work done on that approach
>> yet.
>>
>> Recently Joao mentioned another alternative: the binary stats framework that is
>> already supported by kernel[1] and QEMU[2]. This RFC has minimal code changes to
>> expose the relevant info based on the existing data types the framework already
>> supports. If there is consensus on using this approach, I can expand the fd
>> stats subsystem to include other data types (e.g. a bitmap type for exposing the
>> inhibit reasons), as well as adding documentation on KVM explaining which stats
>> are relevant for APICv and how to query them.
> 
> Thanks for the series. IMO this approach makes sense. May be we should consider adding one more stat to say whether AVIC is active or not. That way,
>   Check whether AVIC is active or not.
>   If AVIC is active, then inhibited or not
>   If not inhibited, then use other statistics info.

Hi Vasant,

Thank you for reviewing/testing. I'll implement your suggestion and send it on the next revision.

Alejandro

> 
> 
> I have reviewed/tested this series on AMD Genoa platform. It looks good to me.
> 
> Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
> 
> -Vasant
> 
>>
>> A basic example of retrieving the stats via qmp-shell, showing both a VM and
>> per-vCPU case:
>>
>> # /usr/local/bin/qmp-shell --pretty ./qmp-sock
>>
>> (QEMU) query-stats target=vm providers=[{'provider':'kvm','names':['apicv_inhibited']}]
>> {
>>      "return": [
>>          {
>>              "provider": "kvm",
>>              "stats": [
>>                  {
>>                      "name": "apicv_inhibited",
>>                      "value": false
>>                  }
>>              ]
>>          }
>>      ]
>> }
>>
>> (QEMU) query-stats target=vcpu vcpus=['/machine/unattached/device[0]'] providers=[{'provider':'kvm','names':['apicv_accept_irq','ga_log_event']}]
>> {
>>      "return": [
>>          {
>>              "provider": "kvm",
>>              "qom-path": "/machine/unattached/device[0]",
>>              "stats": [
>>                  {
>>                      "name": "ga_log_event",
>>                      "value": 98
>>                  },
>>                  {
>>                      "name": "apicv_accept_irq",
>>                      "value": 166920
>>                  }
>>              ]
>>          }
>>      ]
>> }
>>
>> If other alternatives are preferred, please let's use this thread to discuss and
>> I can take a shot at implementing the desired solution.
>>
>> Regards,
>> Alejandro
>>
>> [0] https://lore.kernel.org/qemu-devel/7e0d22fa-b9b0-ad1a-3a37-a450ec5d73e8@amd.com/
>> [1] https://lore.kernel.org/all/20210618222709.1858088-1-jingzhangos@google.com/
>> [2] https://lore.kernel.org/qemu-devel/20220530150714.756954-1-pbonzini@redhat.com/
>>
>> Alejandro Jimenez (3):
>>    x86: KVM: stats: Add a stat to report status of APICv inhibition
>>    x86: KVM: stats: Add stat counter for IRQs injected via APICv
>>    x86: KVM: stats: Add a stat counter for GALog events
>>
>>   arch/x86/include/asm/kvm_host.h |  3 +++
>>   arch/x86/kvm/svm/avic.c         |  4 +++-
>>   arch/x86/kvm/svm/svm.c          |  3 +++
>>   arch/x86/kvm/vmx/vmx.c          |  2 ++
>>   arch/x86/kvm/x86.c              | 12 +++++++++++-
>>   5 files changed, 22 insertions(+), 2 deletions(-)
>>
>>
>> base-commit: 7455665a3521aa7b56245c0a2810f748adc5fdd4
> 
> 

