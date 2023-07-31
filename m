Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E163F769CF8
	for <lists+kvm@lfdr.de>; Mon, 31 Jul 2023 18:42:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbjGaQmL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 12:42:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230181AbjGaQmJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 12:42:09 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB331C6
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 09:42:07 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36VDTL0o011010;
        Mon, 31 Jul 2023 16:41:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=fKITplWzXTVmUlxL+FsHeyy+c5TSx1LVWn9Cwe9nJeE=;
 b=uN1poTG2u+zsMNltdjwhkO58RSTopZN859YNjtkU5DXgzn6zK/Ty6z19EwMts/5k7umo
 6AwTxgueJdDMz3B1zsiJdfC1tpDDN1XB5Vn1Q3ptoa/wfbQw2zn9d5d1Gy3a5+4nGVgz
 XfOMtrCPNzC0b0baxW9l18i8n57zGW8wMeK/sdsmvAByCMJg8zpes4BmjTQZgj9R48tP
 DM7X7MUdMFb3c+1WwCozHMFAtgNbl9GzxLptms2ITyoR+FYj+XMCBei8SJ/j/WOowjR2
 vEDdffv+ar+LyjREFtDhG+ggz5GZrE/iumzoZBMSRijGJEB/vPvfoq/x2EqdpK/jotAF LQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s4sj3u2d1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Jul 2023 16:41:45 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36VFfWmA013577;
        Mon, 31 Jul 2023 16:41:44 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3s4s754gee-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Jul 2023 16:41:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PFAasT3DLHzrpFzMdOKoRGgk99owLkomRV3tXGWF5t/pgn6pR0sZXC/83TN4UW2cKiLxfBN82psJMpSDZcF9tdZWUAGkSXSs66yJUHwmYialG1FlGdAm2VG0/Y3UGf0JHGKtAti9gZ69l09S32zyPMQKH6qIEEtXGzWssicBGIQnCZSpW2MuKLVapj7GqEJXWWdNAsaEdvYplxTLA2Z45NthSV1E+gCaTXiKehIIgHvU3HMrxwXlA7QTK7k+QPeZJERl4l8CrZyULQiuO/3RR71Tkuv+pjBp5KY6vdPyikXe/N6jmsYVMCS0IxO2hHEP0hmylDx3uIoQMwvHDvP3+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fKITplWzXTVmUlxL+FsHeyy+c5TSx1LVWn9Cwe9nJeE=;
 b=BQVsoLk9uVN7oeGGY3XZtrAdLCOPObcWucLe4Nxj8mOxMvB4P/QUxG/yd4h6n4TV/f4Zt3Ff7q8W0LotHIxgCUP5dYdwpb/bDlrzDdOXUeKGLAahcxQ3fJok+Xto7bv/7Bp/NIfDwkmlztJhDv9etCzcdmA/UGMfluSGx1J8052nwRvx8do/v2mvdlGKD4dyo6fk/EF6tAK5+kCU7hyu5HbDktwTA07rX06X1DJ1Ov0F+UZJJwN+glofcGpCYaI7buKcvM5QauaobgfA6Wp5+9DTEaXC6m3eOxqRBTZ3VxGcH8hHzuiE4pLGEc9yrqWOO0ypk9qDwxRhCwfjJUnGew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fKITplWzXTVmUlxL+FsHeyy+c5TSx1LVWn9Cwe9nJeE=;
 b=we/Mml6hDGRcXs3WH4Yd7GF6YBAb9dfRbt9507z+pK/GCkufiorbS4GrvSamaPJvWroSOPijM33JsFD1PptDk85GbO+ktK1UJ+e+1wn0hpLZ2hrPwnMReKxQ5M/Bp1KXK3WXIabbquenXHHEbAkz+Lx8RPBJvYB5myolP1LwJPY=
Received: from PH0PR10MB5433.namprd10.prod.outlook.com (2603:10b6:510:e0::9)
 by IA1PR10MB6758.namprd10.prod.outlook.com (2603:10b6:208:42e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.43; Mon, 31 Jul
 2023 16:41:41 +0000
Received: from PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::76c:cb31:2005:d10c]) by PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::76c:cb31:2005:d10c%4]) with mapi id 15.20.6631.042; Mon, 31 Jul 2023
 16:41:41 +0000
From:   Miguel Luis <miguel.luis@oracle.com>
To:     Marc Zyngier <maz@kernel.org>
CC:     "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Chase Conklin <chase.conklin@arm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Darren Hart <darren@os.amperecomputing.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v2 06/26] arm64: Add debug registers affected by
 HDFGxTR_EL2
Thread-Topic: [PATCH v2 06/26] arm64: Add debug registers affected by
 HDFGxTR_EL2
Thread-Index: AQHZwS3Mg+pTxrM9qE+WSxm3YegxbK/UGVsA
Date:   Mon, 31 Jul 2023 16:41:41 +0000
Message-ID: <61B845D3-A42B-451F-B74D-51B4A1FD28C6@oracle.com>
References: <20230728082952.959212-1-maz@kernel.org>
 <20230728082952.959212-7-maz@kernel.org>
In-Reply-To: <20230728082952.959212-7-maz@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR10MB5433:EE_|IA1PR10MB6758:EE_
x-ms-office365-filtering-correlation-id: da6207b0-5463-4074-748e-08db91e5046f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CJMP83Ischiq4WTz6NLO5nY16Em+/ofnJxXPo3xRdT/BzspWHFurCHdHxYWLmazy/XYtz/8khD7847r1UH+O/s8gukvKH2hT5RW3rUYeJNhyNU7pwugPv5KaxUgy6ecgDrLe7PRmXA6qkPc60dCKV6g39U67XDNHpNLpoQazeMGtHu+OGRGtYykz9TGPlpS36oFDemcLGnsJzVn5lvDDW9Cxkdy40qpfVaKP7/hgpM/IJvzVhpYCif/wowqYGvlYosym03Abdw0+s9tRDbNF7Oaw2bT6Nhh97x5C7LLFUvCZ1HLxNlcsblRbdg7Mo6a3r43LayCY/u6q8SCZBDQTN/5rtMr79VVeJKOCzFYFoAaxJJ9hGlsyhuPVy/b5LUHTE7uH956UvPhITAFHAJKHblXxEkoP6kmewSX0B+sUKVjHHH7B+3l0P4Y65uHoEV92vn6wVgaGIl4jdihqheghJCbHkTBkZ8Ot2NQEF78HPjvRJbR9nLbrdID/u95mcgFSDeV36Mk/2L0bZnUiPrd4Hp8o2dmxJb+eb9PeV7LOe1FE+iQ2IULDsjHJPftZqjv8+kU8nysVCJoU9xgiQsaZTf7eYegnNDGoNYjqXEC2uiEGwgXDjzUToOrkdu9QvS0VxWeN6oB3khYQfsnBlx942w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5433.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(136003)(376002)(346002)(39860400002)(366004)(451199021)(66476007)(86362001)(8676002)(8936002)(316002)(4326008)(5660300002)(66446008)(6916009)(64756008)(54906003)(7416002)(122000001)(41300700001)(33656002)(66556008)(91956017)(66946007)(76116006)(38070700005)(478600001)(2906002)(71200400001)(38100700002)(36756003)(44832011)(6512007)(6486002)(6506007)(186003)(53546011)(2616005)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Nnd4VndURGMrclhibzlubStVU29RdzZ0am4zb1l2MEhqL2NRRjBLRCs1VVll?=
 =?utf-8?B?N3J3QXpEdkROS3ZjR3N2aExkWi9TUnhxTkdJdTRmUGl5Mm5wcGJibzNzWktl?=
 =?utf-8?B?amhOdDVIeDBCaUt6aEk5MjhGcFMvYlVWTzZGT0I1M2xldVVCN3o4WFVUU1Nu?=
 =?utf-8?B?RWhJenk0c1ZUVWdWN0hsajNZT1c5V3J6T2dhcnhPU2Z4Y1hWQkdOclBDNU1C?=
 =?utf-8?B?SHZEU0ZKVW84dWxuVmd6U1BORnVHZURyR0xlMGJUQUNPaDluZldrRldiVk9o?=
 =?utf-8?B?TnZvd3JONjE0azZWdW84UFZDTkwyemQwL0lJUDcybHJpczg2K1BLNTlQWU1T?=
 =?utf-8?B?L0xJK0ZFMzNTQkFWdTVhTFhiZVRoWk5vTFBsWG5NeE9pbkN2MTVFK2h4aGIv?=
 =?utf-8?B?Rk1VOFBlQm9QUEtXT0l5Sy9ZVzFLRXVDdHRybUp3UTVWSzR0VGdudDRrcDdn?=
 =?utf-8?B?UUROdkxVa1R6aWY3dmlFcTgzanVNaDNQZWZhZlNvM2JrWGdReUtnTllkUGNS?=
 =?utf-8?B?eHczNkFvVDIzNDVzVFYxdEQwT1J6cmc3UWZLamdsd2tTTjhBZFNlYkhPUlRJ?=
 =?utf-8?B?S0p1amt6dFNERmZsTGNpeEpRSzlmYXRjK1I4NnJqcGhOUk9MckJ3TklZWnFy?=
 =?utf-8?B?L045dE55M3kzOGlseUJVeGRpTzE0TGRMMzNiWWlabnI2OGJUa2E0Qkx0ZGhy?=
 =?utf-8?B?VjFzVUE3NitaaDBhM2pBU0wyR0FqVllXQmNpSHg2S0lqZWlIYXlCUURuN25w?=
 =?utf-8?B?MXZURXVxRzBWTkthTTJsZWQwajlrTXB0VGtOaWZJOUlndnhZTldMMHFSUFlL?=
 =?utf-8?B?UTkzeHFGbzZXV0R6VXdSUkhrV3prS295RVZiT2MzUmwxOW5XRmhaQ250MktY?=
 =?utf-8?B?aE5iYVlRN0I1U2Q0Z01aYlpybHZRN3dUYk8zaGRzdmtnNndycGFGQ042SG5J?=
 =?utf-8?B?Um5WTERSeUJaTWxYK3hLMFdpUHlNVHUwR0ZvUWRLMmE1S2dKUkVqMjE5SkM2?=
 =?utf-8?B?bUYzc0VVcVFhOEhrZEVidjY4ZWVrMXVid2VYSlIwcTYyWE5ONGFEK0tNU3JC?=
 =?utf-8?B?cVdFQXVQVDJMSXdFNGdYZTdpcDNVYmE2V3A5NEZNVzR0RTlRME83R3drVzVr?=
 =?utf-8?B?MUVOLzU2RzB6UEpTY0d2blBwZHVucFcyR0tWTm5STS9oQ05PazhwbkJXc0ls?=
 =?utf-8?B?ZW44aURqMG1PcXh5L2tpaHdtb0Qyd0JYaFJLelJkaGs0NkoxZzN0VHZLRXl0?=
 =?utf-8?B?Z0pZL2xybExlRmp4U0VNeHN2NEQzS21ubjJxNlZIN1NGS2dkMkNRZmFXcjAz?=
 =?utf-8?B?czlKWUpEcFhSZjFKbDJIMDdoK2xtVUp3Q1lrWU1xMmVJaCtHNlJhY1ltTmpO?=
 =?utf-8?B?UHphR2dmWk5sWFVxcVlMMmYvcFFselpJWng0bGJoSTh4MHNyM0x0cWhRTFk5?=
 =?utf-8?B?cDZLaEFwSVlXRTdwK29JME9xN0E5YUdFcnE5bnB3RlN3TUg0bjZabCswNmVG?=
 =?utf-8?B?M2VwMnZwZDdJNG5tb3BVQmtzY0t0eVhycVRyTzhaakpDTWM3K3gvZ3lIME1w?=
 =?utf-8?B?QXlVMGpscVN0aEJHY2czMTk4TC9Xc2VNcWdNMmQrUHZ3aUNibUFtUU1CQk5Q?=
 =?utf-8?B?RzZEVkVveEhQSmxBd2RWZ1F6akxQTGVUakpSNXZ1ME04RmcvZ1NTZEs3V3Vr?=
 =?utf-8?B?YUhObG5sTXREYlVnWHFGS3dWdkdqL0l2RXJ0NmdVSDNoODkzanppUVhNL0xE?=
 =?utf-8?B?anRUQWFtS3dUWmZUZGFOOURSdVRMQkVRS1JwUUo4L3UyMHd1ckhSQnhhTVY3?=
 =?utf-8?B?aU5FR1NScE1UTU01TUwvcUNIaS96SXJtbFlBUG9SK2lyM1I0RS9GdDJxckFi?=
 =?utf-8?B?MkIzZ1JwTzJ2dDIyZVVRQ0dJZGxlanVyaGtvU0NvWVRVcyt4bG5vRytuNTkz?=
 =?utf-8?B?WitCUjMzVS9NdGJhM1lTbHB0UmU3T290ZG5PcXlJdmgwWCtEakJFSk1yZURt?=
 =?utf-8?B?dnhSVEZ4OVFrZlNLcHN0ZnczcHlJUWdmYjVGOTBqcDF4a0tiU2JWNFY3U3B4?=
 =?utf-8?B?aEdMbVN4SUh0cFdNanFUOWd3UjdreGtNTnhRelc1dEdJM3M3ODRIUDlEUnJv?=
 =?utf-8?B?QTBzQUtZcmcwY2d6R3FaeEszTWQzQ2RUUDA5NTRCbER2WFJSb2dUdEt0eTg4?=
 =?utf-8?Q?pealtcNmmgPN14cv/mN+HNc=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9CCCDD566B65C54280E50D08619423E5@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?Slk2VVJ6VGpUc3Ntb2ZzNEJOQWRGaThMTXFDWGttL3FLc2lGcmtQaHJVeTE1?=
 =?utf-8?B?djc4MmVscGo5RUlaMFdmNHIvTnNnVExjT1hOQjNOWG1vdGtkM1YzUlhWdVRC?=
 =?utf-8?B?cjVBc0VRRzNSSEFXM2FIbGpuVU5uSkZqdVZ1SVZBMXdGSUxBOG1XN1c5VE5j?=
 =?utf-8?B?ODNMKzg1Szl5RjE0d2RQM0ZqdkZHeXA5WFlMVkdVMUxSTnQza3lDT3IrVzZz?=
 =?utf-8?B?SnJNMTV3SWd2ZzlqeTF1TDJGRU9qNEZKa2ZxZzRjSnZTSXFHbDVhY0pFVlVk?=
 =?utf-8?B?a1JoeWZEWlpKWXRSemdEWWYrVjFoTkIxYmVBcGNnUDJraVNFWEpsR0ZqVzA5?=
 =?utf-8?B?N3BQZnI3MHJIc2pJUzh1cEUxK0xZY0EyWG1LY1pTdlZwZEYreU5PSytOdkRk?=
 =?utf-8?B?ckNZSDNRUWRwaHpkY3JTWUhpelNZQjBZeGFlVGt4SGFDTXMvdUQyVDZGR1Vm?=
 =?utf-8?B?R2U3WDFqbEpIaHAzTHV4VElIKzR6bk5HVWQ1eURhQ1MvZHhVQXJLb0VCY1pv?=
 =?utf-8?B?K2tTU3NPZHRJaWRNdTBiWkJCa3h5SUV2TTZMTkhlTGNoOStlNXFiMVNFZ1Rh?=
 =?utf-8?B?T2grVzh5ZW82NW5rUmRGWjY4bksyNlNpdFBaNi9TRUtLbDdicStCRXZlWUxw?=
 =?utf-8?B?T1RWTTVMdUI3YzBuRHk1MkFweHh5eEgvc0U3YXlIYnorRUpWWGtLMzJ6RnE1?=
 =?utf-8?B?d2E1Y2tRQjBCVENsR3IxY3dXUHUrNW5XdGZDSzFyU0tuMTg4cnVyRGNlQWUw?=
 =?utf-8?B?K3RMMkhyb0pLNjZXdFhJWWJvWEQ3NjAxNHdIVTNRYmMwdjZlcTBESDVtclFw?=
 =?utf-8?B?eTlyUjNXakRCakt0MHNlcjBKRW5LQTdraFREd2JFVGRMNVNtWEV0Uy9nZDFn?=
 =?utf-8?B?S2djalM4cHh2WWt1UFV0UTZaM0NuN2htSGhWNlhXWEdGSHB5RlROaGQ1MWVS?=
 =?utf-8?B?TUdnUnBBQWlaODdDNzgrSlpIRkpuNnJsMHpWeFAzSGlhbXdQdkt3Wms4T2xW?=
 =?utf-8?B?RHE4QVNkSU1ZOFlNdE1YcHU2Z1J4SHM2TERnYnRVWFp1dFBycTNTa08vOXI1?=
 =?utf-8?B?cWZqSW5tNG9wWUFjVE1ieWFIMzk5SThEOXpIcVNsTXh1ck45dDB5RDlONjNT?=
 =?utf-8?B?bldsRG5xSXpaT2x4aVB4SHNwOU9xRjNRZEJpemRTenUvMHVRUEI3S2tXbWtK?=
 =?utf-8?B?eDcrd0tsTjVMMzNxTFNSMldNb0NxOXNaK01NWXpRTElyZ0l0OVVjNjZFQ2F5?=
 =?utf-8?B?eVdQSVREN0NJUlk3VlEvZ3hBcWkzR09pUjNGanJjTG5obk5zUEpwdVlvMU92?=
 =?utf-8?B?S0VQSVcycmUyT0JGRXJyWlhQZzB2aWl4Mm12RnFwVEMxekRRb0NReVA5R3NY?=
 =?utf-8?Q?uqYjUGy+4q/PaHgdPolIt5Zzni1SPYA4=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5433.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da6207b0-5463-4074-748e-08db91e5046f
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jul 2023 16:41:41.0663
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: n1zZMWmCzAFe1lcEglLaxFenJgbgVo9pg0rZdpEL+K67Uptbw0jivESdOAnG1ePyQN3vNfkiTYs4id9upyR6xQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6758
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-31_09,2023-07-31_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 adultscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307310150
X-Proofpoint-GUID: kiKoyiDno465reF7aw88A7RRmJ7NKfTK
X-Proofpoint-ORIG-GUID: kiKoyiDno465reF7aw88A7RRmJ7NKfTK
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgTWFyYywNCg0KQSBmZXcgY29tbWVudHMgb24gdGhpcyBvbmUsIHBsZWFzZSBzZWUgYmVsb3cu
DQoNCj4gT24gMjggSnVsIDIwMjMsIGF0IDA4OjI5LCBNYXJjIFp5bmdpZXIgPG1hekBrZXJuZWwu
b3JnPiB3cm90ZToNCj4gDQo+IFRoZSBIREZHeFRSX0VMMiByZWdpc3RlcnMgdHJhcCBhIChodWdl
KSBzZXQgb2YgZGVidWcgYW5kIHRyYWNlDQo+IHJlbGF0ZWQgcmVnaXN0ZXJzLiBBZGQgdGhlaXIg
ZW5jb2RpbmdzIChhbmQgb25seSB0aGF0LCBiZWNhdXNlDQo+IHdlIHJlYWxseSBkb24ndCBjYXJl
IGFib3V0IHdoYXQgdGhlc2UgcmVnaXN0ZXJzIGFjdHVhbGx5IGRvIGF0DQo+IHRoaXMgc3RhZ2Up
Lg0KPiANCj4gU2lnbmVkLW9mZi1ieTogTWFyYyBaeW5naWVyIDxtYXpAa2VybmVsLm9yZz4NCj4g
LS0tDQo+IGFyY2gvYXJtNjQvaW5jbHVkZS9hc20vc3lzcmVnLmggfCA3OCArKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysNCj4gMSBmaWxlIGNoYW5nZWQsIDc4IGluc2VydGlvbnMoKykN
Cj4gDQo+IGRpZmYgLS1naXQgYS9hcmNoL2FybTY0L2luY2x1ZGUvYXNtL3N5c3JlZy5oIGIvYXJj
aC9hcm02NC9pbmNsdWRlL2FzbS9zeXNyZWcuaA0KPiBpbmRleCA3NjI4OTMzOWI0M2IuLjlkZmQx
MjdiZTU1YSAxMDA2NDQNCj4gLS0tIGEvYXJjaC9hcm02NC9pbmNsdWRlL2FzbS9zeXNyZWcuaA0K
PiArKysgYi9hcmNoL2FybTY0L2luY2x1ZGUvYXNtL3N5c3JlZy5oDQo+IEBAIC0xOTQsNiArMTk0
LDg0IEBADQo+ICNkZWZpbmUgU1lTX0RCR0RUUlRYX0VMMCBzeXNfcmVnKDIsIDMsIDAsIDUsIDAp
DQo+ICNkZWZpbmUgU1lTX0RCR1ZDUjMyX0VMMiBzeXNfcmVnKDIsIDQsIDAsIDcsIDApDQo+IA0K
PiArI2RlZmluZSBTWVNfQlJCSU5GX0VMMShuKSBzeXNfcmVnKDIsIDEsIDgsIChuICYgMTUpLCAo
KChuICYgMTYpID4+IDIpIHwgMCkpDQo+ICsjZGVmaW5lIFNZU19CUkJJTkZJTkpfRUwxIHN5c19y
ZWcoMiwgMSwgOSwgMSwgMCkNCj4gKyNkZWZpbmUgU1lTX0JSQlNSQ19FTDEobikgc3lzX3JlZygy
LCAxLCA4LCAobiAmIDE1KSwgKCgobiAmIDE2KSA+PiAyKSB8IDEpKQ0KPiArI2RlZmluZSBTWVNf
QlJCU1JDSU5KX0VMMSBzeXNfcmVnKDIsIDEsIDksIDEsIDEpDQo+ICsjZGVmaW5lIFNZU19CUkJU
R1RfRUwxKG4pIHN5c19yZWcoMiwgMSwgOCwgKG4gJiAxNSksICgoKG4gJiAxNikgPj4gMikgfCAy
KSkNCj4gKyNkZWZpbmUgU1lTX0JSQlRHVElOSl9FTDEgc3lzX3JlZygyLCAxLCA5LCAxLCAyKQ0K
PiArI2RlZmluZSBTWVNfQlJCVFNfRUwxIHN5c19yZWcoMiwgMSwgOSwgMCwgMikNCj4gKw0KPiAr
I2RlZmluZSBTWVNfQlJCQ1JfRUwxIHN5c19yZWcoMiwgMSwgOSwgMCwgMCkNCj4gKyNkZWZpbmUg
U1lTX0JSQkZDUl9FTDEgc3lzX3JlZygyLCAxLCA5LCAwLCAxKQ0KPiArI2RlZmluZSBTWVNfQlJC
SURSMF9FTDEgc3lzX3JlZygyLCAxLCA5LCAyLCAwKQ0KPiArDQo+ICsjZGVmaW5lIFNZU19UUkNJ
VEVDUl9FTDEgc3lzX3JlZygzLCAwLCAxLCAyLCAzKQ0KPiArI2RlZmluZSBTWVNfVFJDSVRFQ1Jf
RUwxIHN5c19yZWcoMywgMCwgMSwgMiwgMykNCg0KU1lTX1RSQ0lURUNSX0VMMSBzaG93cyB1cCB0
d2ljZS4NCg0KPiArI2RlZmluZSBTWVNfVFJDQUNBVFIobSkgc3lzX3JlZygyLCAxLCAyLCAoKG0g
JiA3KSA8PCAxKSwgKDIgfCAobSA+PiAzKSkpDQoNCkJlc2lkZXMgbeKAmXMgcmVzdHJpY3Rpb25z
IGl0IGNvdWxkIGJlIHNhbml0aXNlZCBpbiBvcDIgdG8gY29uc2lkZXIgb25seSBiaXQgbVszXS4N
ClN1Z2dlc3Rpb24gZm9yIG9wMjogKDIgfCAoKG0gJiA4KSA+PiAzKSkpDQoNCj4gKyNkZWZpbmUg
U1lTX1RSQ0FDVlIobSkgc3lzX3JlZygyLCAxLCAyLCAoKG0gJiA3KSA8PCAxKSwgKDAgfCAobSA+
PiAzKSkpDQoNClNhbWUgZm9yIFNZU19UUkNBQ1ZSKG0pIG9wMjogKDAgfCAoKG0gJiA4KSA+PiAz
KSApDQoNCj4gKyNkZWZpbmUgU1lTX1RSQ0FVVEhTVEFUVVMgc3lzX3JlZygyLCAxLCA3LCAxNCwg
NikNCj4gKyNkZWZpbmUgU1lTX1RSQ0FVWENUTFIgc3lzX3JlZygyLCAxLCAwLCA2LCAwKQ0KPiAr
I2RlZmluZSBTWVNfVFJDQkJDVExSIHN5c19yZWcoMiwgMSwgMCwgMTUsIDApDQo+ICsjZGVmaW5l
IFNZU19UUkNDQ0NUTFIgc3lzX3JlZygyLCAxLCAwLCAxNCwgMCkNCj4gKyNkZWZpbmUgU1lTX1RS
Q0NJRENDVExSMCBzeXNfcmVnKDIsIDEsIDMsIDAsIDIpDQo+ICsjZGVmaW5lIFNZU19UUkNDSURD
Q1RMUjEgc3lzX3JlZygyLCAxLCAzLCAxLCAyKQ0KPiArI2RlZmluZSBTWVNfVFJDQ0lEQ1ZSKG0p
IHN5c19yZWcoMiwgMSwgMywgKChtICYgNykgPDwgMSksIDApDQo+ICsjZGVmaW5lIFNZU19UUkND
TEFJTUNMUiBzeXNfcmVnKDIsIDEsIDcsIDksIDYpDQo+ICsjZGVmaW5lIFNZU19UUkNDTEFJTVNF
VCBzeXNfcmVnKDIsIDEsIDcsIDgsIDYpDQo+ICsjZGVmaW5lIFNZU19UUkNDTlRDVExSKG0pIHN5
c19yZWcoMiwgMSwgMCwgKDQgfCAobSAmIDMpKSwgNSkNCj4gKyNkZWZpbmUgU1lTX1RSQ0NOVFJM
RFZSKG0pIHN5c19yZWcoMiwgMSwgMCwgKDAgfCAobSAmIDMpKSwgNSkNCj4gKyNkZWZpbmUgU1lT
X1RSQ0NOVFZSKG0pIHN5c19yZWcoMiwgMSwgMCwgKDggfCAobSAmIDMpKSwgNSkNCj4gKyNkZWZp
bmUgU1lTX1RSQ0NPTkZJR1Igc3lzX3JlZygyLCAxLCAwLCA0LCAwKQ0KPiArI2RlZmluZSBTWVNf
VFJDREVWQVJDSCBzeXNfcmVnKDIsIDEsIDcsIDE1LCA2KQ0KPiArI2RlZmluZSBTWVNfVFJDREVW
SUQgc3lzX3JlZygyLCAxLCA3LCAyLCA3KQ0KPiArI2RlZmluZSBTWVNfVFJDRVZFTlRDVEwwUiBz
eXNfcmVnKDIsIDEsIDAsIDgsIDApDQo+ICsjZGVmaW5lIFNZU19UUkNFVkVOVENUTDFSIHN5c19y
ZWcoMiwgMSwgMCwgOSwgMCkNCj4gKyNkZWZpbmUgU1lTX1RSQ0VYVElOU0VMUihtKSBzeXNfcmVn
KDIsIDEsIDAsICg4IHwgKG0gJiAzKSksIDQpDQo+ICsjZGVmaW5lIFNZU19UUkNJRFIwIHN5c19y
ZWcoMiwgMSwgMCwgOCwgNykNCj4gKyNkZWZpbmUgU1lTX1RSQ0lEUjEwIHN5c19yZWcoMiwgMSwg
MCwgMiwgNikNCj4gKyNkZWZpbmUgU1lTX1RSQ0lEUjExIHN5c19yZWcoMiwgMSwgMCwgMywgNikN
Cj4gKyNkZWZpbmUgU1lTX1RSQ0lEUjEyIHN5c19yZWcoMiwgMSwgMCwgNCwgNikNCj4gKyNkZWZp
bmUgU1lTX1RSQ0lEUjEzIHN5c19yZWcoMiwgMSwgMCwgNSwgNikNCj4gKyNkZWZpbmUgU1lTX1RS
Q0lEUjEgc3lzX3JlZygyLCAxLCAwLCA5LCA3KQ0KPiArI2RlZmluZSBTWVNfVFJDSURSMiBzeXNf
cmVnKDIsIDEsIDAsIDEwLCA3KQ0KPiArI2RlZmluZSBTWVNfVFJDSURSMyBzeXNfcmVnKDIsIDEs
IDAsIDExLCA3KQ0KPiArI2RlZmluZSBTWVNfVFJDSURSNCBzeXNfcmVnKDIsIDEsIDAsIDEyLCA3
KQ0KPiArI2RlZmluZSBTWVNfVFJDSURSNSBzeXNfcmVnKDIsIDEsIDAsIDEzLCA3KQ0KPiArI2Rl
ZmluZSBTWVNfVFJDSURSNiBzeXNfcmVnKDIsIDEsIDAsIDE0LCA3KQ0KPiArI2RlZmluZSBTWVNf
VFJDSURSNyBzeXNfcmVnKDIsIDEsIDAsIDE1LCA3KQ0KPiArI2RlZmluZSBTWVNfVFJDSURSOCBz
eXNfcmVnKDIsIDEsIDAsIDAsIDYpDQo+ICsjZGVmaW5lIFNZU19UUkNJRFI5IHN5c19yZWcoMiwg
MSwgMCwgMSwgNikNCj4gKyNkZWZpbmUgU1lTX1RSQ0lNU1BFQzAgc3lzX3JlZygyLCAxLCAwLCAw
LCA3KQ0KPiArI2RlZmluZSBTWVNfVFJDSU1TUEVDKG0pIHN5c19yZWcoMiwgMSwgMCwgKG0gJiA3
KSwgNykNCg0KU2luY2Ug4oCYbScgcmVzdHJpY3Rpb25zIGFyZSBub3QgYmVpbmcgY29uc2lkZXJl
ZCwgd2hlbiBtID0gMCBpdCBjbGFzaGVzIHdpdGgNClNZU19UUkNJTVNQRUMwIHNvIG92ZXJhbGwg
U1lTX1RSQ0lNU1BFQyhtKSBhbHJlYWR5IGNvdmVycw0KU1lTX1RSQ0lNU1BFQzAuIElzIHRoaXMg
cmVkdW5kYW5jeSBuZWVkZWQ/DQoNCj4gKyNkZWZpbmUgU1lTX1RSQ0lURUVEQ1Igc3lzX3JlZygy
LCAxLCAwLCAyLCAxKQ0KPiArI2RlZmluZSBTWVNfVFJDT1NMU1Igc3lzX3JlZygyLCAxLCAxLCAx
LCA0KQ0KPiArI2RlZmluZSBTWVNfVFJDUFJHQ1RMUiBzeXNfcmVnKDIsIDEsIDAsIDEsIDApDQo+
ICsjZGVmaW5lIFNZU19UUkNRQ1RMUiBzeXNfcmVnKDIsIDEsIDAsIDEsIDEpDQo+ICsjZGVmaW5l
IFNZU19UUkNSU0NUTFIobSkgc3lzX3JlZygyLCAxLCAxLCAobSAmIDE1KSwgKDAgfCAobSA+PiA0
KSkpDQoNClN1Z2dlc3Rpb24gZm9yIFNZU19UUkNSU0NUTFIobSkgb3AyOiAoMCB8ICgobSAmIDE2
KSA+PiA0KSkNCg0KPiArI2RlZmluZSBTWVNfVFJDUlNSIHN5c19yZWcoMiwgMSwgMCwgMTAsIDAp
DQo+ICsjZGVmaW5lIFNZU19UUkNTRVFFVlIobSkgc3lzX3JlZygyLCAxLCAwLCAobSAmIDMpLCA0
KQ0KDQpXaXRob3V0IGNvbnNpZGVyaW5nIOKAmG0nIHJlc3RyaWN0aW9ucyBDUm0gY2FuIGNsYXNo
IHdpdGggMy4NCg0KUGxlYXNlIGxldCBtZSBrbm93IGlmIEkgbWlzc2VkIHNvbWV0aGluZy4NCg0K
VGhhbmtzDQpNaWd1ZWwNCg0KPiArI2RlZmluZSBTWVNfVFJDU0VRUlNURVZSIHN5c19yZWcoMiwg
MSwgMCwgNiwgNCkNCj4gKyNkZWZpbmUgU1lTX1RSQ1NFUVNUUiBzeXNfcmVnKDIsIDEsIDAsIDcs
IDQpDQo+ICsjZGVmaW5lIFNZU19UUkNTU0NDUihtKSBzeXNfcmVnKDIsIDEsIDEsIChtICYgNyks
IDIpDQo+ICsjZGVmaW5lIFNZU19UUkNTU0NTUihtKSBzeXNfcmVnKDIsIDEsIDEsICg4IHwgKG0g
JiA3KSksIDIpDQo+ICsjZGVmaW5lIFNZU19UUkNTU1BDSUNSKG0pIHN5c19yZWcoMiwgMSwgMSwg
KG0gJiA3KSwgMykNCj4gKyNkZWZpbmUgU1lTX1RSQ1NUQUxMQ1RMUiBzeXNfcmVnKDIsIDEsIDAs
IDExLCAwKQ0KPiArI2RlZmluZSBTWVNfVFJDU1RBVFIgc3lzX3JlZygyLCAxLCAwLCAzLCAwKQ0K
PiArI2RlZmluZSBTWVNfVFJDU1lOQ1BSIHN5c19yZWcoMiwgMSwgMCwgMTMsIDApDQo+ICsjZGVm
aW5lIFNZU19UUkNUUkFDRUlEUiBzeXNfcmVnKDIsIDEsIDAsIDAsIDEpDQo+ICsjZGVmaW5lIFNZ
U19UUkNUU0NUTFIgc3lzX3JlZygyLCAxLCAwLCAxMiwgMCkNCj4gKyNkZWZpbmUgU1lTX1RSQ1ZJ
Q1RMUiBzeXNfcmVnKDIsIDEsIDAsIDAsIDIpDQo+ICsjZGVmaW5lIFNZU19UUkNWSUlFQ1RMUiBz
eXNfcmVnKDIsIDEsIDAsIDEsIDIpDQo+ICsjZGVmaW5lIFNZU19UUkNWSVBDU1NDVExSIHN5c19y
ZWcoMiwgMSwgMCwgMywgMikNCj4gKyNkZWZpbmUgU1lTX1RSQ1ZJU1NDVExSIHN5c19yZWcoMiwg
MSwgMCwgMiwgMikNCj4gKyNkZWZpbmUgU1lTX1RSQ1ZNSURDQ1RMUjAgc3lzX3JlZygyLCAxLCAz
LCAyLCAyKQ0KPiArI2RlZmluZSBTWVNfVFJDVk1JRENDVExSMSBzeXNfcmVnKDIsIDEsIDMsIDMs
IDIpDQo+ICsjZGVmaW5lIFNZU19UUkNWTUlEQ1ZSKG0pIHN5c19yZWcoMiwgMSwgMywgKChtICYg
NykgPDwgMSksIDEpDQo+ICsNCj4gKy8qIEVUTSAqLw0KPiArI2RlZmluZSBTWVNfVFJDT1NMQVIg
c3lzX3JlZygyLCAxLCAxLCAwLCA0KQ0KPiArDQo+ICNkZWZpbmUgU1lTX01JRFJfRUwxIHN5c19y
ZWcoMywgMCwgMCwgMCwgMCkNCj4gI2RlZmluZSBTWVNfTVBJRFJfRUwxIHN5c19yZWcoMywgMCwg
MCwgMCwgNSkNCj4gI2RlZmluZSBTWVNfUkVWSURSX0VMMSBzeXNfcmVnKDMsIDAsIDAsIDAsIDYp
DQo+IC0tIA0KPiAyLjM0LjENCj4gDQoNCg==
