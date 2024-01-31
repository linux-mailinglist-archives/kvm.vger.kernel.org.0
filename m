Return-Path: <kvm+bounces-7595-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 72A9C84457D
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 18:02:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 28D34296CD4
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 17:02:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5454D12CDB1;
	Wed, 31 Jan 2024 17:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YaMUvB35";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="HH4NeBtd"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2541412BF1B;
	Wed, 31 Jan 2024 17:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706720552; cv=fail; b=Dm6QuebZOlWmJnjM59B05fFCU5LpJlZ7nTNxEqN/iuv37ZvyFveyvRt073d5HQUjSOAezf6zpXzm2G11BDzbTlEoIAJOIu03ynduWlxHBI3joTsBSip/o7JGsxfRuqmbg2KTE/AKnmql9tYjHgjGRaCIOvDVLeUUHqeyvqyjHZA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706720552; c=relaxed/simple;
	bh=cqzjkJ2k6Hd4P25SmA/3J0j5EMgSaReznupgWgp93DU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=W5LOCvVS3M5JbBrWOrOo1ihaq1p+l/PD1SAmSVGwD0FCg+wQ3e8c23rNwXmUu2VvSNK0h6GpT5rpWOwxXVDKgIDtyiWt5ifwGH1MKW9TRskZW+xl98J9TqzTHIv9O+61/UivZuYDI2VOMC2pdMcgZfPRMnm2pFENXYW2G15r3ZM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=YaMUvB35; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=HH4NeBtd; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40VEwqp9005451;
	Wed, 31 Jan 2024 17:02:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=HnGhD/dYYEqC4q2Hgos0TXeCEnoV7w7CMD1AOofUejg=;
 b=YaMUvB35i/5GRndlfBeBkW4o7kQzol76733yyA6g8FX6NKs8Xuig4wFbBAWtRWTwUztO
 J0ZD4ulOoIZqcfYywpH2fddXuDeVI6pybAGV6Kka+7YiJta0e0mo9WRUUKahBImdJJFK
 +mlef7pAuoaLQNUELyw5vxHigkzfOLMdCqUwkbH/CSj2jYNBNhPX+2kPZBfVGuiBkxZt
 FggYolUuCegE8edqToc+beRO6F12cj/yNHQdfqUKSexi+ChCFcAvQrvEEiD63Oe0zWZ2
 qBl/m58dINu/3FtpGW9vAyakaI6g1OAlSHhX7ZCIebss8h9pTVNbksFCYA5HU1Cuwpw9 Lg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vvsvdtd1j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 31 Jan 2024 17:02:20 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40VH0nSG028467;
	Wed, 31 Jan 2024 17:02:19 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2040.outbound.protection.outlook.com [104.47.56.40])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3vvr99aaug-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 31 Jan 2024 17:02:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aWgYXCbXpSIJCZRzGNwX+S+XwlOHlGZbIXqznHmQV0Ll3TIfsmxReHbKjN+/cDRn0EWVi5XcnK/C5qt4AgYgZXjY6DEBIRqesbwuD9i+iWobE4NAVos7ydFKBjTWxcf/lhBCobst40NvH9aBjg5vW+BgJHDMfGEijaDYQhJz+KUjd2CH5Wo95zqgEx5VoKag0TYeYevFdRr2+pgNWLIGOiGlO6CMoZBn2vkLWZcsGxpOAhg16sJlQtNT5ysbQ29rk3NFH/gTp3GZRMcIzI/m2iOEW8YT8GPM51CX5I+rxm7r42bdMoDTDHioEKRCYzFz87L9VN/8MTXxop29G/KAGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HnGhD/dYYEqC4q2Hgos0TXeCEnoV7w7CMD1AOofUejg=;
 b=Rc7U77T4XNhHiN88fIx3G2cK8nw+T1MTgLzp8eLVHusT/4TTqbeOR6XpjZsSG/P/YLZ3FyutkavTBH6SciO454firNYNzSxhMV4paamd2gR8yhYAJqfrspS3bP0pXs4tw39217UwMY2DeSAiZ6doKTwZEWiOCju/Kf1eRNl8EOZt5jimrAy2bOze/L2kCWwirYfm/fLrLVM1/EfBIuQL/c36GSu7o2GZ8OYvdMEJ+hoLazscxO4k1MhHsP8b0kvEHJMWC/riWRVNebqoj508aVa6/LDr/JFC8fPjlauEEc/PYWXR//H2rnnXv0hbY2Q7eBLRdfRroX3I39djx0aAIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HnGhD/dYYEqC4q2Hgos0TXeCEnoV7w7CMD1AOofUejg=;
 b=HH4NeBtdVFmHHcuBVf4MoK9DMZl7gwZITS3dJlKfTJ9gVQA1y+P4HQrq3+WnsEbbFZA9ZaN9CPnaMlhcZHpM9AAGJcgtKkGx/H9aruVJkN07eBbmyZNvnUgYfoCpY7gKehENpHYuHQbCY3m01afwvwgZ1BbWnhLnnS9kPKHgdjA=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by CO1PR10MB4580.namprd10.prod.outlook.com (2603:10b6:303:98::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.34; Wed, 31 Jan
 2024 17:02:17 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a1c5:b1ad:2955:e7a6]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a1c5:b1ad:2955:e7a6%5]) with mapi id 15.20.7228.029; Wed, 31 Jan 2024
 17:02:16 +0000
Message-ID: <368248d0-d379-23c8-dedf-af7e1e8d23c7@oracle.com>
Date: Wed, 31 Jan 2024 09:02:11 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH] KVM: x86/pmu: Fix type length error when reading
 pmu->fixed_ctr_ctrl
To: Sean Christopherson <seanjc@google.com>,
        Mingwei Zhang <mizhang@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20240123221220.3911317-1-mizhang@google.com>
 <ZbpqoU49k44xR4zB@google.com>
Content-Language: en-US
From: Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <ZbpqoU49k44xR4zB@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0226.namprd13.prod.outlook.com
 (2603:10b6:208:2bf::21) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB2663:EE_|CO1PR10MB4580:EE_
X-MS-Office365-Filtering-Correlation-Id: 9add1b59-a0a7-472e-7990-08dc227e60f3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	nxl0/6jxb8LivOhOGW0Z2xd+tDV9lwrs4pJpQt8Gsx/Dwfm24b315B9Wa2JkLT81DuZxYr6JDgUiII8TCfu67fOsgu7YRDlfs/apvzLbBh/6HhhEVHZwtPA1HTcNghPrTX677dsc3mkjNzVMRB84D0gmqbJbeV7GC5B3lMBJ8kSgrRmrcyO9L9qv57G0zPz79lOE+weC0cy4H1xL1CC2zyGP7y5d4ZhI6mtWss+Imv1c+dFN6Bw/lT8gW72biCKKWmswXZpqpdw/1VqDbc4YhyqghrWmo6WJJ6iFLdF9sj+gu00qv0dzttUqCJvDZtOQxUFfmPgbtGQgkmNi5CO7zUzwmjClDLVbgSNzaVHKaaSupxlyzPrdVd+XN8zjZ2BXMB+wEm016HYy/JS6vRxjvQO9aMEo2aygx7nibphsQcQ1Ju4Kg176r57fArhTU8tyAjT8Ne3N6IwpDrEYIuHRwjv8W39ynqunsKQ4evLPPMt4gurkcd+MW5IF+i2Wz/UJRxxsHfpnaiTJpM86zMXivOPjCNxDNU1HrQbWDaeQ18lVF6xlwvs8DjJzJK8C7H7IIjf8iWnAloYPzyGBXyS8pc7vfBwh8KCxpvpB44/fQfv9QztuxdvkRnB6iduIPNeXk+jFdj+oUvreUYoLBDfJlw==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(366004)(136003)(376002)(396003)(346002)(230922051799003)(1800799012)(186009)(451199024)(64100799003)(41300700001)(26005)(2616005)(31686004)(36756003)(6666004)(53546011)(478600001)(6512007)(83380400001)(6486002)(6506007)(38100700002)(316002)(86362001)(5660300002)(31696002)(2906002)(8936002)(66946007)(54906003)(66476007)(66556008)(110136005)(4326008)(8676002)(44832011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?SExzdjBiMFVXR0VzZ3FicDlERHRkT0prSVNkS0tqZStBeU96RmFSZXFaZ2tW?=
 =?utf-8?B?UG1YUmhkSSt5TThjV1lYNkdCWFFYMklPeENsWFRFSy9BUlVMQ2ZBOE02SEFI?=
 =?utf-8?B?enRNMXJkcXJQRDFQdmRPMU1XTjZBa2I1ZllrbnBmZlRwckRzMFV1Z0ZMK1Iv?=
 =?utf-8?B?MEVzK2x0QjZ2RlZoRWdsa2xhdTZqUWZQZUp0NDZrT3B0Tm0wMWFOZ0Vsc2Jo?=
 =?utf-8?B?YmxKRDV4NTdpUmY2MFE0RmFDdVZJWnk1YVJjbnpnbGhwTEpmVHlTUTl6SmxS?=
 =?utf-8?B?YU5Wem4rODVjV0FMSWFWWEkzVGt4STlma1V1V1RyT1BWSjVKa2hWcHcwRDZG?=
 =?utf-8?B?cVV5bHpvZ09kTEJnZ2F3L245d015cStTdzRKVDF6NTJCQ2RHS2RuS1JCT21M?=
 =?utf-8?B?ak1pZDJnWTFxRkxMNVJucjROMi9EUVpVTFk4RGRBV0d3aTg4cVBHbzNpU0xB?=
 =?utf-8?B?RzFleG9OOXJZemljRVNGMG53NDd0REFPbWhXMUxsU1FpZGQxUVBYNmxEZ3Vt?=
 =?utf-8?B?eUN6MHJZWmJqNHlVQjYwNFBLMFBWNms2Zy9ITVpYbHFYVWNDelJ1Ykl1YlBI?=
 =?utf-8?B?QzdSM1d6Q0JkSjhXVlNVNTJBRk1pTjBqTVhqdTB3Z3UwQitXSXlRK3hsSFpF?=
 =?utf-8?B?Y01abUdJeVU4enRyVXU2U1RoQUhzWTlITWdiSzZCdnNCclRxK3VPUGcxTkRo?=
 =?utf-8?B?MUg3RXV1NmhPVzdQYXNmQnZ5MGRVK0VnQTdtMGxZdmcvWTJHRkE0T2QzU0ow?=
 =?utf-8?B?WUhqRHdjR1A4VkVDZzdPOTI3MERxT3RvekdFaGZPSS9JWmdHM3dBeitTejBP?=
 =?utf-8?B?akJsMStMaTZmeEdITGgyb0p6dnFHSTZ6SWhNTmlrNFVtRDJyWFh2T2t1cVlI?=
 =?utf-8?B?YnlqSklXRnRFdjhNVkczZTZybzNYNUIxRWdqZFpqZ2xlUnBSY0JrbFhZemVD?=
 =?utf-8?B?blEzdGw0dUlaNUlaRkJ1aHpvckdOUGcyaFd0bEVXOFgyQ2pDRFhDdTVKbGZo?=
 =?utf-8?B?aVU5cTZFbUdLK1pkelpYYWpwUUd6RURsYjYyT0RIYkhrVmFyNk5iUTc2bkYx?=
 =?utf-8?B?aDJvcFZhODhKeVJLV09qbWpCOG9wNC9iR3Y1TlFlSFBWcC93VUxXdm5MWVIr?=
 =?utf-8?B?SzBPdnUwcnhrVUVmOGVjMTg3SDNSOUVCaUtxZU1idlRPZzNqanhWbDlzSm96?=
 =?utf-8?B?clcyU2pyaGV0WmVrbGtEejRvaVM0clJucEptTGtlYjVhYWVzMGpEYlg4R09p?=
 =?utf-8?B?TDRHS3c3OTlYMTJ2NWcrclBYbnZaQTVKOXdhL0g2S2I5MXlKaVd0ekFXSXlR?=
 =?utf-8?B?UUE0K2FzcE1id1dybnRaYUYwMmwzTHlndDRsVjhFN3V1ZHRrM3MraTc2V3RX?=
 =?utf-8?B?K0JPeE85NHhzR0Q5VU9jZ2krakJONWZpVFlpcWRkNkczZUJrTXNwNTF0aDND?=
 =?utf-8?B?cXAzOFVva1N2dGNBcXdLVUxJZ1RqbjVERDRZOEVGdnpJZXF1QU5CS2piWFJF?=
 =?utf-8?B?TVZuOW9rY3R6QmNsb0JnVm5kR1YzSXBreWNKRFRVTlF2K0FsN3Fzb3dTaExL?=
 =?utf-8?B?OURaaWVFa1ZYVW4yLzR6YUtUeE5RVTQ4d3lWcTRrNFUrWEtDZFJiekJDUUc3?=
 =?utf-8?B?ZllNM1ZlREg4bVBvWkRSS01CNml3LzMweHJOTE55ZlJKRVI3cEVSOTVjK2pq?=
 =?utf-8?B?b3o3ZkdCSTFzai93cVJSMXRrcnhsYzNHU01vM0QrNnpzN3dxMHZDVHVjSFh0?=
 =?utf-8?B?VEFpMHdCREt1bWhqUTV4UTgxMklOOUNwRTM2RkhKSWNQY3BvMFBCbExGazMr?=
 =?utf-8?B?cTRtbkRWVWE3NTlUVUdYazlNNHpjY0hQaVdTc1NybHI1bDFjYTRhOTMzWjhV?=
 =?utf-8?B?RHRaMXhXWitMN1ZUUEhQNDB0Nkc3ckQvaUZRYzl5end5bzRZaitUbGFRTGhK?=
 =?utf-8?B?Q1ROdng0SE9RNEdlUW9GMkdxcDg0RGZkTWxwb05JOGRCZ0o1am1qRHRpY203?=
 =?utf-8?B?aFp3MTdFZnc5Skt2TlpwUS84UEE2UXR4TmZkVG9NQTVBQ0lUaTdvNFNNNXBZ?=
 =?utf-8?B?WnBsa00rdUMwMFQxaEd2QThyWVN1S3dZT3JrZ2hsTFRpNWFrS0dSbXh5bk5K?=
 =?utf-8?Q?cUKKvvmZOGhMmiOML6JVYHEsv?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	MV3+dJ3zhJhXgHIFB283y1adJQokLHr0VPiSQIx8R39R/plMN4gLEYg6YGBYwHChprmalbz699gMggk3mkLgjnjClQnvsNE5G+Ytfi7YxS9htUc8Fa1x1HD5RV1elXT0CBb3BgtqWtPqq8MZ8zkD0m7fS9whmOj/FzwOquk1CqWy4588uxEseX90/9QKGJCv8GJ7nawo/uEzFLFtZFxGApF/yYa97aCgcBfznQNdmdeo59nYEKhmDxwt9WR9BRRZwOKNiEZDTocZGbvlOkzRMlJ/v7xGUNlYZV8pP1YCsSr/lDoeDV9Ugy/sXJ3Ag9h1S+tng2cJlldx+gdtYBgAOfvukiHcNsJr3g0NYsh+S4Vk3gpRIhuQLF78lXkyc6ATlkt1cCWUtPRHYDjBzHIdrLxVfUf1GwOf+ACQUgtq/yaZn8g9/smCJYufs38xPhNbOL4fpeO13Vm4L//Iz+OeGe0FqRLIqtphUTy7BYcQFGNbd5i7R3wTKoad0ryXhXD1qa8NSY2R2xYdByFIX+JOTDcRNCpL6do0rtTsPXnSporazCzYC7KD7vjoAG34MjKrLpGDU2MZdRQ5gV+9taZokzx/o485oGoGlceQS4d3gCI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9add1b59-a0a7-472e-7990-08dc227e60f3
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2024 17:02:16.8580
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9jn2IsuIrxBhvSjNfMrPm2ElsKl7Y7M4RlEOP425riUe3GsDdROF0Xh6tJkWMjB51hUAuqSaoDVORKpCOdR1Rw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4580
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-31_10,2024-01-31_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 mlxlogscore=999 spamscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2401310131
X-Proofpoint-ORIG-GUID: Qzq0wbZMLSfkPodrOW-N7NnwtEPuunXY
X-Proofpoint-GUID: Qzq0wbZMLSfkPodrOW-N7NnwtEPuunXY



On 1/31/24 07:43, Sean Christopherson wrote:
> On Tue, Jan 23, 2024, Mingwei Zhang wrote:
>> Fix type length error since pmu->fixed_ctr_ctrl is u64 but the local
>> variable old_fixed_ctr_ctrl is u8. Truncating the value leads to
>> information loss at runtime. This leads to incorrect value in old_ctrl
>> retrieved from each field of old_fixed_ctr_ctrl and causes incorrect code
>> execution within the for loop of reprogram_fixed_counters(). So fix this
>> type to u64.
> 
> But what is the actual fallout from this?  Stating that the bug causes incorrect
> code execution isn't helpful, that's akin to saying water is wet.
> 
> If I'm following the code correctly, the only fallout is that KVM may unnecessarily
> mark a fixed PMC as in use and reprogram it.  I.e. the bug can result in (minor?)
> performance issues, but it won't cause functional problems.

My this issue cause "Uhhuh. NMI received for unknown reason XX on CPU XX." at VM side?

The PMC is still active while the VM side handle_pmi_common() is not going to handle it?

Thank you very much!

Dongli Zhang

> 
> Understanding what actually goes wrong matters, because I'm trying to determine
> whether or not this needs to be fixed in 6.8 and backported to stable trees.  If
> the bug is relatively benign, then this is fodder for 6.9.
> 
>> Fixes: 76d287b2342e ("KVM: x86/pmu: Drop "u8 ctrl, int idx" for reprogram_fixed_counter()")
>> Signed-off-by: Mingwei Zhang <mizhang@google.com>
>> ---
>>  arch/x86/kvm/vmx/pmu_intel.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
>> index a6216c874729..315c7c2ba89b 100644
>> --- a/arch/x86/kvm/vmx/pmu_intel.c
>> +++ b/arch/x86/kvm/vmx/pmu_intel.c
>> @@ -71,7 +71,7 @@ static int fixed_pmc_events[] = {
>>  static void reprogram_fixed_counters(struct kvm_pmu *pmu, u64 data)
>>  {
>>  	struct kvm_pmc *pmc;
>> -	u8 old_fixed_ctr_ctrl = pmu->fixed_ctr_ctrl;
>> +	u64 old_fixed_ctr_ctrl = pmu->fixed_ctr_ctrl;
>>  	int i;
>>  
>>  	pmu->fixed_ctr_ctrl = data;
>>
>> base-commit: 6613476e225e090cc9aad49be7fa504e290dd33d
>> -- 
>> 2.43.0.429.g432eaa2c6b-goog
>>
> 

