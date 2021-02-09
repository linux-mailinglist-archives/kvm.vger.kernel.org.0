Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9294314C9D
	for <lists+kvm@lfdr.de>; Tue,  9 Feb 2021 11:14:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230489AbhBIKMe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Feb 2021 05:12:34 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:34352 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231351AbhBIKE3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Feb 2021 05:04:29 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 119A0aPn196331;
        Tue, 9 Feb 2021 10:03:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=l44+c+LbswCPOzU1HDJ/DtfOmchz4MjwFOOGJKyU0Ds=;
 b=s9CoZoKPW/DSp1qSZaSk03xuQNZKjz9siuF5ggK8UDHfN2P3P5iz9V7tj3Eyt20gTiRt
 yxVqp5DBbav/ggLIgEl+WWV+pFDchNFl85sXZvDvXHKdbaNCA/tbCsiUbPgweLelZGg/
 xZHQvpHKIVFUxCHno28iJPQij/u1ip0DjskHNsfaWCRBRJ5MO8v33HIVhZga2JJJOaVx
 Avnz+wM4q8PJtP2aqVPGcSFtjA2abscYYxQCGaZdFo8zut0VSyfwK1QUjEXxQgB0bSgA
 sydHZ01AreS07TqBdecEoGcrMb5kpp2oQUA98flASwwttqRDfXXTnALRqIi7gmImKyx6 hA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 36hjhqpx6h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Feb 2021 10:03:30 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 119A0wdb080144;
        Tue, 9 Feb 2021 10:03:29 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
        by userp3030.oracle.com with ESMTP id 36j51vva9q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Feb 2021 10:03:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bmssXOIK1T1AC2pYy5/53V5XmYRZcy7gBtwzyxn+v3Pi1H+E9nPU6zg6HbzQnVdxPMtvcMNxLkmH/1cpkgn+tY45JNSES8ddFCL9DlzDfBOR/jLxso2C4Iw3wYrrfu/hPvkmZ5QhvZ2QmAKxgP2XsviQGqJegcaufxLytn2g7Zd627PCx8JSqT7qtkrCwk3t+FFzOV+OPYVfsXfBr3/G/+8fz0g+IPKJI+2oGPWYs6ZQAdkYer20D2xrPIl1RUFDYDPQs92A8j5SD2NZH7hxEUtpqe+flXMS3+Aor0sF66Jf0j0NOZby4BZma2o+jr66nRpgO32zQ3KlHCsr7XzDKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l44+c+LbswCPOzU1HDJ/DtfOmchz4MjwFOOGJKyU0Ds=;
 b=bk/ff8eabsLt739urDovoJAGruN59zHOUQtPeMWP633AbVWeJdwNgmXYl+vXymZ/vEeNQ6ihDghA4exk2JDqWqPoNvu5sYjBPLltV/MwtEPWBZLSeUlneXF3IBeFZCj8N0WVakTb/naSQmACJexOeYgRFUKNovnfbzcfngkW8LqeZZI45VXxURAW6dsckmLYuoA4aoaqcfvRmp5f8w0KoaaOYWosvEok9JqI/3Mhw62p7tn5QYfYhRECWhidqJKp7GZ5m6yFf5XRR56Tjh9xXypPFKtZAf06VsE0z59HCtbEaz5WHLM8Pcp2rIu6R1URk/4M8AqRuewnAm5fWcCKIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l44+c+LbswCPOzU1HDJ/DtfOmchz4MjwFOOGJKyU0Ds=;
 b=GezApZY+n55AiQeL2VYz5MSi57EtkjDoLptdBYxjUiVM0Kd3aI0HjwP7BQcHoe4rPJkhxPapFPy619d0bk/m6ZbxMNeQWUSeE5bVS3YZxu0QGZjN6fJzhZhw6akgws/Keni0D7sibrwwJICpFC8JR0wH36THdDjj1WNvvoohosY=
Authentication-Results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3077.namprd10.prod.outlook.com (2603:10b6:a03:8c::12)
 by BYAPR10MB3159.namprd10.prod.outlook.com (2603:10b6:a03:153::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25; Tue, 9 Feb
 2021 10:03:27 +0000
Received: from BYAPR10MB3077.namprd10.prod.outlook.com
 ([fe80::74a8:8649:e20b:d571]) by BYAPR10MB3077.namprd10.prod.outlook.com
 ([fe80::74a8:8649:e20b:d571%7]) with mapi id 15.20.3825.030; Tue, 9 Feb 2021
 10:03:27 +0000
Subject: Re: [PATCH 2/2] KVM: x86/xen: Remove extra unlock in
 kvm_xen_hvm_set_attr()
To:     David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>, graf@amazon.com,
        iaslan@amazon.de, pdurrant@amazon.com, aagch@amazon.com,
        fandree@amazon.com, hch@infradead.org
References: <20210208232326.1830370-1-dwmw2@infradead.org>
 <20210208232326.1830370-2-dwmw2@infradead.org>
From:   Joao Martins <joao.m.martins@oracle.com>
Message-ID: <ff030393-ce7a-3599-036f-1b4620cc0ff5@oracle.com>
Date:   Tue, 9 Feb 2021 10:03:20 +0000
In-Reply-To: <20210208232326.1830370-2-dwmw2@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [94.61.1.144]
X-ClientProxiedBy: LO2P265CA0291.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a5::15) To BYAPR10MB3077.namprd10.prod.outlook.com
 (2603:10b6:a03:8c::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.67] (94.61.1.144) by LO2P265CA0291.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:a5::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19 via Frontend Transport; Tue, 9 Feb 2021 10:03:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aa9f168c-33d2-4432-dc39-08d8cce1f1d6
X-MS-TrafficTypeDiagnostic: BYAPR10MB3159:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB315974690F3B7AE7319764A6BB8E9@BYAPR10MB3159.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:227;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Q0otLaj+RH1su6XRSlRKwjwHSsruQ9/45I/ztD7ln1sAJr0DyoxvtLmu7jdk/ld3w3Wf11SCr74LB9S+8T63JkFng18CndC3thIWfhjA4P/YwREoAuuBTXD2yABjj1N6wf7QW6/DdkDnBUhqDd7i4LN9yh6/HZ6jIDLNwTZ4VE5bD07DmGWtXJhF+JTCh9uYVsFYKMaSFN6CLjcMdNI88f2xtGFs+KDBsQqZSC5cn/fDE0mSqjQPUD283J19rrgDBJVJoREJq5oIz5h8kfkf3b8x5hWbcTfmKZOLdxUAA3PCykkThAlfCmzBolqRGjDiR95vktwA1Q5rciZz1vXs1KeDwSmpndC28Q4hY/olGBypgN2DHdJnuUXqD79PvypERYCaTcyQ/lffgM0jCKhj6Bn18Jhj9RuocDmGSc2ENAMbIvOlknE3vfi+fi3d2sWCcMQccCP8Bdj1YIrmWqaK/Y5/EmveaC28i9mcYKeE+oJUzS8uXdNZj1wJN7ga5E1uaTsRx0cXCm6AlqzdnzCPRtOD+oDRSmIrKMESZXI6O2QUA6SQuSPjM94GPACpni97CRToI+gbt6mX8lUw15umSg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3077.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(39860400002)(396003)(376002)(366004)(53546011)(6666004)(2616005)(31696002)(86362001)(956004)(16526019)(186003)(26005)(31686004)(7416002)(36756003)(8676002)(4326008)(83380400001)(6486002)(316002)(16576012)(54906003)(478600001)(4744005)(5660300002)(2906002)(66476007)(66556008)(8936002)(66946007)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?c2svbmNFbXBRMTFYZDVTVU5XVEhYLzB0bkR4RnVuOWx5SC83N2ZxM3J5TjE3?=
 =?utf-8?B?RWJtSnNqaVFQbnYwdythY3dLM1RmcXljc1RLQmxaVTVScjBqb3UwZ280SUsr?=
 =?utf-8?B?ZDl0Rm1ZWitRR2JVdGJIMWh6MFhleGxRaG4venppbTMzNUtDendhTi9MVHpi?=
 =?utf-8?B?Vmh5YjkzaVUzSEtsQ3JweENZclBMUGRXazBwQU9vRS92M2srbk1IYWRZMzZv?=
 =?utf-8?B?Y2wzVmsrOGRhOG5ibExTYlgyRWpuY0k4L0gxRkxMaGp2b3EvcTk2dVBzLzBH?=
 =?utf-8?B?Zm02VEc1Z04xTU9EU1dVZXNhUE5sYjdVcEZnVU0vYk1qVm1MMDFKL3UvRGxn?=
 =?utf-8?B?d2RXWTd0dWJXVlk3amNiTVIva0g5aDJodUU0TS9mdWl5RCtSUksybFhCbTBp?=
 =?utf-8?B?RUxicW16cWxWb081emFid1VPdy90bWpwMWVLaXJGN05NMlJqZkFKdHFuVXQr?=
 =?utf-8?B?dW1WMjRGUk9NSzBuNThMM1JNR0xyTVVMVk1VbDcyT3o0ckZkL05wSmNDT3ov?=
 =?utf-8?B?ZEcxT24wN3p5K0tZb1BNNHhGUms0dVRNWnVFUHNMVXN2L0pKVHBiT3V3a1VO?=
 =?utf-8?B?YjZkYnl0TVRZd1ZzSWRXRXZFQXM1T0ZhWUJoRHlhanZmUGRGdkNXNEZrV2l4?=
 =?utf-8?B?MlRuRHR1R2xOZS95cFlQY0Y1UzZRUERGL0pCcWNhenc5MVhsREVqZHJBK09I?=
 =?utf-8?B?TkczYjA3TWxXakpBZjdVN0ZUZGo4L1NTdEp4QU9TUnU5c2JRNVFabUxLMmdX?=
 =?utf-8?B?VUovcjlFNE96UitjOXVSRnBRWU5BSHl3c1UwZjZWYlpSbFZPaklJSUN5cVVh?=
 =?utf-8?B?WG0rT29VS08wWFZNK3JWVWNrazlXYWNMVS9YNEkvS1lIb1g3QnNhQ05kMjhu?=
 =?utf-8?B?amh4cTVqSUlsN2R6RHhVWXpVRkV0a0x3ODdxUm1QY0xwcEZLZlZmbmV1Qlhh?=
 =?utf-8?B?bHpQV0FnT1BBOUZBVEc2ZnczdHNycGxvRmlsZUZTUW1vdkFuRXRuS1B4NjE3?=
 =?utf-8?B?R1ExU3ZKcFRMSGUya1YyRllPeGhaVnZ3L3lRdThUcFVmMEVyMjJ5NFRQR3hQ?=
 =?utf-8?B?Yk1OR1REajZJU1BCd2FNTlE5UCtCeXBYVDFKMDk0WVpuSllFaUVJYjNNd1Ey?=
 =?utf-8?B?L3JmYmZrRWYyMmppSlBIekxVZmk5aUJBcXBRcktDdzFLRnRWODNWMnBSeHNr?=
 =?utf-8?B?YVQvb2Z0WDA1QW9OTFFxdmRoSStKcjFyMGwraDdZQnpEWlBUZHM3UHFZQ3Aw?=
 =?utf-8?B?SVpjOEx3Q1BsQlFZUEp3d3ZiN2tDYkhPbWFJT1Q5a0ZFVDNXZ1BxSmw1SFpB?=
 =?utf-8?B?cThTUXorWUdtb3BFQndRTi9aeWtSeXRKblA0MHBucVI3alVhR2lYTmtMVTdu?=
 =?utf-8?B?ajNKcVUwbWQxdFdvYmZrTlNZMHVJVG9mZU1TYU9BaEFnYTRnNGdRK1BodEJo?=
 =?utf-8?B?cE1EVHhZV3l2TlAzL0VWQ24zckZqM3FWb3NZN2hFSjBKVExVRzVqTG5LZDF2?=
 =?utf-8?B?TlFnTjFYQXE2bkhmMU1udkcxbGk4b1BZWThib05DM2ViSWpZN3l5c3RsUUJJ?=
 =?utf-8?B?RXNTUzV1OExhdHpORE1QbjhiNmUrRVY0Rk1vOERZSVcvV3NOQnZUekJoaUN6?=
 =?utf-8?B?WUxCZjZ5QVF0Q2RIbFlpd3Y1YlFXWitheElYaHVUbXgvU0ZhNC9MRTNpd1NR?=
 =?utf-8?B?bXdTNzVrUXptTTJ6R21LcDcvc1NKZU0rYXRqS2xCZ2EzU2I0OGwwVnNqMjRB?=
 =?utf-8?Q?578mqr7liGyox0sMcNo9deSHTS+55enNLZmy0OC?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa9f168c-33d2-4432-dc39-08d8cce1f1d6
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3077.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2021 10:03:27.0952
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LNN4Py6Sc0423Gqhgek5musYkrVdaJRpwnCIGmQCTo29ctnzlySyXQgGZJzOK+2P2jrxVxlf2A5Dxis/Yc7IRZnP8FoK1AeVbkLfieEX1Gg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3159
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9889 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 mlxscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102090048
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9889 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 impostorscore=0
 priorityscore=1501 bulkscore=0 suspectscore=0 mlxscore=0 phishscore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1015 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102090048
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/8/21 11:23 PM, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> This accidentally ended up locking and then immediately unlocking kvm->lock
> at the beginning of the function. Fix it.
> 
> Fixes: a76b9641ad1c ("KVM: x86/xen: add KVM_XEN_HVM_SET_ATTR/KVM_XEN_HVM_GET_ATTR")
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>

Reviewed-by: Joao Martins <joao.m.martins@oracle.com>

> ---
>  arch/x86/kvm/xen.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
> index 06fec10ffc4f..d8cdd84b1c0e 100644
> --- a/arch/x86/kvm/xen.c
> +++ b/arch/x86/kvm/xen.c
> @@ -105,8 +105,6 @@ int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
>  
>  	mutex_lock(&kvm->lock);
>  
> -	mutex_unlock(&kvm->lock);
> -
>  	switch (data->type) {
>  	case KVM_XEN_ATTR_TYPE_LONG_MODE:
>  		if (!IS_ENABLED(CONFIG_64BIT) && data->u.long_mode) {
> 
