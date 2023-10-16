Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D69367CAE0B
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 17:47:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233751AbjJPPrz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 11:47:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232310AbjJPPrx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 11:47:53 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDC53E6;
        Mon, 16 Oct 2023 08:47:50 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39GCd6h4002205;
        Mon, 16 Oct 2023 15:47:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=v42uI7dZb4k+EcjJKiieuy61T1C/+F/Yfaw1N6npk5g=;
 b=P6H3e7w41pF/1RCJtYUFlbAHpfhtzviJM1Bsm3Ks/2aPCGcZ6y9B6jClMqz7pNHHY1Uj
 3d02mFMQGKqmcV00scAfnEcDHPLZdlDG6xblWio+s+J+q0NO09Fkp/JXQ7jWJu6WU9CS
 gyY4RZA3aQ3uxV+FDhd2MT6BZxgwgewiJd/KNQ9YBwduoy+eaTqkeSmRd3ypEaKtAdDm
 Jqn2bC0k5Ba53RePX/15rQdc3y4dcNzqBTMhc1RXfHjDieHpJq5c+QEE9fGU26sHtPNh
 4P7WXgb95kVRNdOvZ/XEw4Ab5RVCQM5rT5FW52udOcimlZ9qxFHfYgRHaUEC7MEqcq8q 5A== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tqk1cu3hr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Oct 2023 15:47:21 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39GEd5C3027980;
        Mon, 16 Oct 2023 15:47:20 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3trg52kw8p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Oct 2023 15:47:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aoPsw+uz2KGFooJHfrTpr2x60KxRJjeUdwtfVcdcWD8LruGeKKzQ//Zi7MYWURaW6d1C5zuTaZdpkQyMtGs0y1GkO8nLYPgEjY09wXl1ko2APrxxpfcZRaPi2RACTYouMUvb93swIS5xDLt9uJWoyi+junUD8T4Nj5Z8ShRNBzc0elnbQhup7vY+ui4d8ldvGWkiC4nj21XTBGC1U3M/Snu9g5ZQS/5jut7iSRJ1xkY4+6ODBpyWEURB/g/gdK5bakbtJe8ubACXHeV/A5Znfj+zcGgvlLhTThaPaF2G5WgZrIRfy+QThrAwQBZWfE9IXHc7WZcJJo6lR2js+b16tA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v42uI7dZb4k+EcjJKiieuy61T1C/+F/Yfaw1N6npk5g=;
 b=Vp1/ZD8REUq64zeT/dJfpFbNDzAZfJswqzkbDP4kvQp2BMg9lOAHeyrUSnDkedsPeT/NS4GyVC9Kaax6mgvAXvelNnU36Q/W6j9aNZxVEBoDIEuvMxAa9NRBiIh205jE+VX1MeH08eRNZUKiTiDCb4DuKKq9ob9tMkCIUSyvZl4YedzoX6AemWLFxxdAtJZ0VXJtMMLWAMq5Wp/sE0MiuEmNZYu2scGY4KL5QyQrFszgeU6ysGKjv2bPbACyRg3PyOra2iSfxq0TDTyVsTW4GptxxyvyVp7s27pkXEHcF3QEjwbW0JCoYIVlCIc3yM7JKDr8QKfTvWavwyC/K2m6pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v42uI7dZb4k+EcjJKiieuy61T1C/+F/Yfaw1N6npk5g=;
 b=OS2KSD1gZpgMwCdcnPqGpyKlmEfBYj7PwTUO99UH4aIv+v7w9Zmp9AHfHOnEmcY8amBBVc+1S4myHa9/87Lo11sA5eZnPVZ7KBtUX7VM3Dtr2QI6lOonFc0mSaY+QRvcQo8W+42C3HOYk/1nbMCHBTzbAIsGg3uqtqR+bihg6tY=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by PH0PR10MB5628.namprd10.prod.outlook.com (2603:10b6:510:fb::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.47; Mon, 16 Oct
 2023 15:47:18 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::8e27:f49:9cc3:b5af]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::8e27:f49:9cc3:b5af%7]) with mapi id 15.20.6886.034; Mon, 16 Oct 2023
 15:47:18 +0000
Message-ID: <993cc7f9-a134-8086-3410-b915fe5db7a5@oracle.com>
Date:   Mon, 16 Oct 2023 08:47:15 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH RFC 1/1] KVM: x86: add param to update master clock
 periodically
To:     David Woodhouse <dwmw2@infradead.org>,
        Sean Christopherson <seanjc@google.com>
Cc:     Joe Jin <joe.jin@oracle.com>, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com
References: <ZRtl94_rIif3GRpu@google.com>
 <9975969725a64c2ba2b398244dba3437bff5154e.camel@infradead.org>
 <ZRysGAgk6W1bpXdl@google.com>
 <d6dc1242ff731cf0f2826760816081674ade9ff9.camel@infradead.org>
 <ZR2pwdZtO3WLCwjj@google.com>
 <34057852-f6c0-d6d5-261f-bbb5fa056425@oracle.com>
 <ZSXqZOgLYkwLRWLO@google.com>
 <8f3493ca4c0e726d5c3876bb7dd2cfc432d9deaa.camel@infradead.org>
 <ZSmHcECyt5PdZyIZ@google.com>
 <cf2b22fc-78f5-dfb9-f0e6-5c4059a970a2@oracle.com>
 <ZSnSNVankCAlHIhI@google.com>
 <BD4C4E71-C743-4B79-93CA-0F3AC5423412@infradead.org>
Content-Language: en-US
From:   Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <BD4C4E71-C743-4B79-93CA-0F3AC5423412@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR10CA0006.namprd10.prod.outlook.com
 (2603:10b6:a03:255::11) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB2663:EE_|PH0PR10MB5628:EE_
X-MS-Office365-Filtering-Correlation-Id: 8dca2e1d-97a7-4b1b-390d-08dbce5f2d34
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lH1H9sj2cbbEqZGzSrf3moDBNpkGZe8tRcSQb2EtsuzAbdMZAVkDIHDJN3fOerDCMAFTlDfNNlOZe4q7vFfMChSn/2VQ/c3h87K7e2zAyg9N7pkLm1LXnHp5pdPS7vqVjr9N0931KYVZVqoY5q57pwTHqnTm2QpGFIdVNSCZyGxEbvX5JQOYIlb096JdiccGZqIdGfHNr3M7DB8cSrls8IMXHRqY7zR4IKt+dnfsCYhBItf+AJI51iKWAafqyEcxJBWdCZ39Cr37fs6Bu0bNjKfGDJ5V18ttgmq4lvX2+aJHstOvlGHzFOlX5oapXbq4CueWm/bXBnSulR6bAZ0451VYUFZzErbUseWdAwksjnYH/uGW15+v4yE+dD0F00broueiDfrM7koyOw+cYiAUjWdmXi3MBbZIxjnSqs6moi/xAWXNbaV8UMecyNDy3sORMIgWM6hJz31Oass5NKuG6iV3uPmCa1o6lC4joU1GFGWJmdoaQo10cF2f0dtAUnScCwCfW0t/Hwa0i8IY44B4Y2sSBkWePMABXZUY2/thN8LYVA+QsNVJssb0wNQz75vaVkTjsAx3L0Q9PBqzbGLj3x4eUHQuDxN6tECi59CJUpsgiEcv2Hu0bgbJhE+xLY2f29g1J9nWvbKoYFhp3wgftQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(39860400002)(376002)(396003)(346002)(136003)(230922051799003)(451199024)(64100799003)(186009)(1800799009)(6512007)(66899024)(2616005)(6506007)(6666004)(53546011)(83380400001)(8936002)(6486002)(7416002)(4326008)(44832011)(8676002)(5660300002)(2906002)(478600001)(15650500001)(41300700001)(316002)(66556008)(66946007)(110136005)(66476007)(38100700002)(26005)(86362001)(31696002)(36756003)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dUpwa2FnQ0NqcDZBU042eHBxOUo2VkFlT3JZWUU1WkVYU3A1ZHpoK2NEcEVw?=
 =?utf-8?B?TDV2TGk3S0lYbjJnZ1ZEVUJkSmhIU3dmRC80L05KU0NKZmNkQURPZWFyTU1L?=
 =?utf-8?B?WUdiaENLMk9pYUFWV0gwNEZlWDdmbXRPUUgzdVNEMlVvRUplWUNTZTJXUFJO?=
 =?utf-8?B?N2FsTDZpTGF5WTI0UzhiWU8yY2NPSTM0WG0zU0hVSG5xaGZOMXB1dmR1RHUv?=
 =?utf-8?B?MloxTUFLd2lHejRHSTE3MUV5ZnJOL1pUT05iT1pucTZ1allEd1hiR0FyYUFX?=
 =?utf-8?B?OUpMcGNhRnZEOGkrai9QMEFZNWk4Nk5xdUZPL1gva3pQT29TSXFWYXFLcXVE?=
 =?utf-8?B?aWV4Mm1hUXVHUlRrQU41clI0T1REMHZESjByY3AzQ3ErLzRTbytkL0NMMHBs?=
 =?utf-8?B?ZXBmZXA2VktrZXcvL1JEb05PRkQvcFZvMS9nWHM2SVh5RVNFYzlveE9neE9I?=
 =?utf-8?B?U1UrVTRTWitxRThlOTMvbnJMZ09IL2NCZi94MkViVXpMTG15MWFLV3d4Q0Ft?=
 =?utf-8?B?SFQ3SXB5elRpVzA5eW9oeDNSVnFCUjJFbmRYaGJyUS92WFBpVEhvc3NkYThR?=
 =?utf-8?B?dVdoNlhnR0V0aytTNmlHeTdMcnFmQ1ZkTnpiRStQem56YWwzd1gwS1FLbWNi?=
 =?utf-8?B?RERxbTVkK080UzdPSmQ5VjlzTW5aWEhIYlh3MVZDN0UzM2JBbFdmMEpWZ1hM?=
 =?utf-8?B?UUhSMGRZZVIzaWNDemRWNkUwM2RFVklHZC83UC8rN0cxQ2lBVmg4cm9XVnd4?=
 =?utf-8?B?b2hoTVBhKzNJZWZHTzRtM0JFVzJzR2RJenRHdGRPdEJWdXFlV3dTdmpYKzl1?=
 =?utf-8?B?SGxJUm9CVE4za1V4bVo4eDdHbEkxZU5IOEsyOHpaWGljSFJUaFJESE5SRzIy?=
 =?utf-8?B?WFZDejFqTDIzcG5YbXRoSTVSV25pT2xtcE81blo3V0ZpVFFNQ3M1YXVEdHBW?=
 =?utf-8?B?a3hhTnFjcXI0RllBVlNYZjhVNHA1eHRlRFNuT1Zkb0w0dklNazF0QTZLN3Q4?=
 =?utf-8?B?Z0s1Q0dKbzducm1CZFNGRDBRazlyQVFVOExmV0VVTDdwM2R1R2wyU0tTUmZW?=
 =?utf-8?B?UEdCUDNMeCtpTzIwWXdyQnFtU25LNThVNXJERjlNQ1lOZGd0c3dMT1luZ212?=
 =?utf-8?B?UDhMMXh5N3R5Y0IxSG8zcnRscno5UEZwSnBTS1hLNDI0Z3ZNOXBpaUJzRWd4?=
 =?utf-8?B?N2d3Q3owbUZpUFREd0tOVlZYa2U4b2ZSVXBYYUloYmtCemR5dUxQSUFDa2xS?=
 =?utf-8?B?M1FkUjZtZEFoTzZOUXNlOTlEbUtqU1NLVWdUeTJuK1ZybnVibzRqQXdDck1Q?=
 =?utf-8?B?UzEwWEZQaHhHZ2JOY1NGSnZ5OHJrRHVYaGFFU1dITk9qZDVnUzdsRzFJT29t?=
 =?utf-8?B?Q0cwQkxIOThWbEhlWW94RElPdFdPVXhNNGUrRjMrNXFYT0pUWmcrQ1o0QW5V?=
 =?utf-8?B?dkxxNVBkVGNRQmlyQmhwRFhZcnlYN2owZWJmVVNQQjhqc2ZUbkY5TUNBNGtt?=
 =?utf-8?B?cWx6WnFTbzBPS1JUb3EyTGU4WjMvVytNZ3lIdFIrZEwyOG5EaWR5RUllN1JT?=
 =?utf-8?B?bWdrYmVjT2t1OTdQUU1WRisydnBxTFlYeHZNdWdjVEdueVEzWVg0YW02eGpj?=
 =?utf-8?B?SXVpZUpyb1F4b1RvSGpZOFZLL2t6VGNWbzl5WU1MSnkvcWd0MHFGcDVJdmlG?=
 =?utf-8?B?N0xmeDZyL3QzQkV6QlpFbzh3U3ZjYmhENi9aUzdMZ3I5WWFvWXdmRDhCSTJs?=
 =?utf-8?B?ZmRYYUxPUDduOWhsVTgvbVEzSTJLbmN2VHVCSGdXWmVtVEpVM043QUl4bGpM?=
 =?utf-8?B?MXZ5QjlXNGU0RlJYbzZ2dXVOMGxzZXVVRG94NEhrRVZmdjcycXNNRFVMeVJW?=
 =?utf-8?B?elFlY3dkZ0xVM0RyVUc1bHRDcTB5amt5VFh2dTNBWmVmSGVJREpkUkw1OW01?=
 =?utf-8?B?dEtUN21DamtxVzljK2pVRjgrTVlyWHBRNzNrcjRUcElDRG5aK0hLVnQ5UDEv?=
 =?utf-8?B?UHpZVFpsMUpUUDVZNUllaFFIZkFjaXJiRm0zYjdVTUVGTU1kTC9aSFRsSGJN?=
 =?utf-8?B?MTZCZkZaS1NJTHR2V2sxcEFiN0ZtREdGTGdSRDBiZGNpQ1hZRzhBMzNKNlUv?=
 =?utf-8?Q?GEi2n9zcqsB1OpjJdStTUh20B?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?cW9MOW8ycXoxVmROdTNTVDJGdDNheEZCeEZyL0NjVW1BQ2d2NmVaTi9RNWRQ?=
 =?utf-8?B?SXFhRG55d1F1TW1vRjkxaGhwMjE5dUFvTlg0dmJwcm9zSno1VlFIWWVzZFlR?=
 =?utf-8?B?V09mb0ROaENRUVlmWlBzWUhjZFdWaGRQYXdraWt2eHpaUDRtZUNySjZmdzRv?=
 =?utf-8?B?TnRIL1J2K2pSV21VRFU0aFIxaFk2cC9XSzc1VWVRU1NNY043RGlTZG9ibXFx?=
 =?utf-8?B?bW13b1g2ckYrdDE2SHl1QXBweFJRM1Y0NDZleTZ0YjhqZEIzMzVLVFJ1SFFv?=
 =?utf-8?B?Sk1KaWpkdlFZdjVoTnRqUU1YdnRzT0dVcXp4STNRV2JsbTB1Ti9EZVpOVUx4?=
 =?utf-8?B?aUNXWVl3TnkvWC9XSnlWc3RNWTBXMnJ3d3lkaXlIZE5ESitnVnJWQmpIZFhW?=
 =?utf-8?B?aGlGVXI0RExQODdJVGdZQlFybDlOV095YjU5R2c2dGtWQzZuZkVYZW1RYllY?=
 =?utf-8?B?ZlhseFpsb3MvWDl0eVg5WnVPMExTaXVCT0x3OGlsdlVUQTZHQ3FXMjhMT2Fq?=
 =?utf-8?B?MkpUQjVJWkVBVFdQWHRZNnNac3hXek52dmdGajFoeHpjM1Y4SFFxd3NjOW40?=
 =?utf-8?B?Z3NRczNwWWFseEp3Vldyam03citIdDNuTUlCYmVaNUk4b3liSU9nMWRnZitO?=
 =?utf-8?B?dllTR3dQclFLblYzTUVYZzBZaUpIbUx2OE0vNE4vc1B3eGdsQ2ttMUlSanha?=
 =?utf-8?B?VkYvSTNvT1hxNi9rLzZaUlc3MkVIWTZ5R2FkWXlGTXRXdGRhYkJ3NXNXa0E5?=
 =?utf-8?B?NzFrbFoyK3JWUzdTemh5K2cwVU5lMkNzaDF6WlR5a2FIRHJWRkxlaUhvLzJS?=
 =?utf-8?B?dDZNQlRudG9RbjdSWUt5TzBIVmpncldRalhROWpBa0w4TWFmZ2pZdXVVSEIr?=
 =?utf-8?B?QWtZZC9UOXlxUkJMK3RDQkxjVnlHdXFrVHlxV3ZWeExWc2Q2UHAzZHp3K2Nh?=
 =?utf-8?B?MmNKUFQ1SEdyc0dYNVVOU0haSjRpWWMrV3pKZG9rZlA2b3BtN0JYZFJCWjhE?=
 =?utf-8?B?VXUzc3RFcFZOeGFnaUtHK3NPQkdUK1Q2bWs3SnNMUkRpeXFmdnIwT1ovNUI2?=
 =?utf-8?B?K3l6Qy9yWEFMaEMwcDZhREdzSUYvdUZRYkxQWW1ZZHh5ZE9tQ0V4aVVBckJF?=
 =?utf-8?B?TjI1OG9HWlF2KzdzaTByR2FucnhvOGdLd29NUW0rN29FT1A4bGUvR3p2VSt0?=
 =?utf-8?B?aVRhYzJYcnJiNWlCcURXdWowdWpOM0lEclpDbG5oWHpoeGJPVHRqR2d2VHZ1?=
 =?utf-8?B?V2gvWEZHYjlxMUhrZm1qZXR6V3VwZGZmeTd6T1JianZXZzVEWS9uRk9ibFgv?=
 =?utf-8?Q?p3ryAxpbYnaJtGqmG9oyK5lkucSFaSepgS?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8dca2e1d-97a7-4b1b-390d-08dbce5f2d34
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2023 15:47:17.9805
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UtuJ+N0U+qD6ZbAg5k9X67+pey3h0lyhYkzIvp6riYUACzz6XXDgBmXm6yuQN4B8sbpAyLeIdnAsccLBm401Mw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5628
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-16_10,2023-10-12_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 malwarescore=0 suspectscore=0 mlxlogscore=999 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310160136
X-Proofpoint-GUID: _aPMn1tvSQt1MRLeqO4oth4tHfs7BvDv
X-Proofpoint-ORIG-GUID: _aPMn1tvSQt1MRLeqO4oth4tHfs7BvDv
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi David and Sean,

On 10/14/23 02:49, David Woodhouse wrote:
> 
> 
> On 14 October 2023 00:26:45 BST, Sean Christopherson <seanjc@google.com> wrote:
>>> 2. Suppose the KVM host has been running for long time, and the drift between
>>> two domains would be accumulated to super large? (Even it may not introduce
>>> anything bad immediately)
>>
>> That already happens today, e.g. unless the host does vCPU hotplug or is using
>> XEN's shared info page, masterclock updates effectively never happen.  And I'm
>> not aware of a single bug report of someone complaining that kvmclock has drifted
>>from the host clock.  The only bug reports we have are when KVM triggers an update
>> and causes time to jump from the guest's perspective.
> 
> I've got reports about the Xen clock going backwards, and also about it drifting over time w.r.t. the guest's TSC clocksource so the watchdog in the guest declares its TSC clocksource unstable. 

I assume you meant Xen on KVM (not Xen guest on Xen hypervisor). According to my
brief review of xen hypervisor code, it looks using the same algorithm to
calculate the clock at hypervisor side, as in the xen guest.

Fortunately, the "tsc=reliable" my disable the watchdog, but I have no idea if
it impacts Xen on KVM.

> 
> I don't understand *why* we update the master lock when we populate the Xen shared info. Or add a vCPU, for that matter. 
> 
>>> The idea is to never update master clock, if tsc is stable (and masterclock is
>>> already used).
>>
>> That's another option, but if there are no masterclock updates, then it suffers
>> the exact same (theoretical) problem as #2.  And there are real downsides, e.g.
>> defining when KVM would synchronize kvmclock with the host clock would be
>> significantly harder...
> 
> I thought the definition of such an approach would be that we *never* resync the kvmclock to anything. It's based purely on the TSC value when the guest started, and the TSC frequency. The pvclock we advertise to all vCPUs would be the same, and would *never* change except on migration.
> 
> (I guess that for consistency we would scale first to the *guest* TSC and from that to nanoseconds.)
> 
> If userspace does anything which makes that become invalid, userspace gets to keep both pieces. That includes userspace having to deal with host suspend like migration, etc.

Suppose we are discussing a non-permanenet solution, I would suggest:

1. Document something to accept that kvm-clock (or pvclock on KVM, including Xen
on KVM) is not good enough in some cases, e.g., vCPU hotplug.

2. Do not reply on any userspace change, so that the solution can be easier to
apply to existing environments running old KVM versions.

That is, to limit the change within KVM.

3. The options would be to (1) stop updating masterclock in the ideal scenario
(e.g., stable tsc), or to (2) refresh periodically to minimize the drift.

Or there is better option ...


Thank you very much!

Dongli Zhang
