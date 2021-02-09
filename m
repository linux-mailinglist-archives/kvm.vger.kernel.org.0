Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88A16314C83
	for <lists+kvm@lfdr.de>; Tue,  9 Feb 2021 11:10:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231474AbhBIKF7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Feb 2021 05:05:59 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:33622 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230207AbhBIKDs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Feb 2021 05:03:48 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 119A0jpf196373;
        Tue, 9 Feb 2021 10:02:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=4Q0ulAubckD+Np5i79ylRGMQj8MiigQzFD5AVhhL/cQ=;
 b=OjNM2fdTliC2gr7SXCVwFIEIYgfkghQrQqvzr090OIOQstGWwkbj25zTtnrJOdbOr2HW
 Iv/XHLndoYII7kYLcGWMKyY81YYYYSxyU8gpbsP218xxcQIB4gQ+CeUNywZhDxxCja5z
 4PxL+IDawRHFKrYjH8SUp72/3QSvGDr/5vZBBU0X/15KK6sdfuMabozjxSqdxBZjf3Je
 niYvrrmumoYJFLB2BeemoWoNtt2TJtX+HZLqltNRMyfdG67l+3EalZOklZvgw5jypvtK
 BT9ss0CMoEzRVJccMdyOQcaqtwzgl0zCq2xxPitUo6oDCoCc1MgaGZW3BjnJtzlKW5Fd 2A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 36hjhqpx44-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Feb 2021 10:02:56 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 119A0xN9080181;
        Tue, 9 Feb 2021 10:02:55 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by userp3030.oracle.com with ESMTP id 36j51vv9q2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Feb 2021 10:02:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jk9d6hpCGvZiGnnszzAkq4EkmrnKB77UfxANtR2OoUSR6VWsNo86qIqepLK0RVl2x9Bl8HAZEmPewtbHHvsd+NPXJyF1cPrXWQ5HVoNepOgnx/pQvBFCr2IBnTgVuv3QAZnEmX7WWIx5EOu9wgyr/wQ34vdpC5VNOHk2Y8U2OUeONuXJZEzSk0Ie9GzYyoEngMdav7ZdlPxLLOiJFGplp/I5TuYPRcNGFePYGMRs8HPN23rzW9kv5n++pZ3gvtFRCuvPkW2HdzvAVrItXFaYzpn6QTIWu9nD/klE57s4SXTpZeud9e/renjwd8SwUt4n8KuPa5ovM/zZV6WoibH90A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4Q0ulAubckD+Np5i79ylRGMQj8MiigQzFD5AVhhL/cQ=;
 b=cdHzXVLuaVpQwTgthNiE8QZVgaCCw1OpxHXVzfCS/cYH3eK+lwn3uqmMljAqbOvo8ngEsC5x6GirfOv2ihckU0ATQz/Ghv2aeJahTyhILYutnvIAHUzWrc6EcoELK+W5k6TVFhQLEQIzZNIRMFwk8MTOKLUUuYtGUcEbwBTL9F5GNuY4rcYimHYds5JMYlgHy6hRjJlhjzJGdCU2YtPn6hoGhhP10n8B3+JbnmIVLedQNRkeBBJujBApSOSzj7n/MnqvF00TmdcbLOI0BuemFXeycFcdHyc0/rYqGmnsSpYudC6xc7d7f3BlO68jLNrwvykVGVG3sU730DKrHLa5nQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4Q0ulAubckD+Np5i79ylRGMQj8MiigQzFD5AVhhL/cQ=;
 b=LW/Mffar8nuh/bOVfIV+j7D/NKCcBOPQue7l4Z+h1TZwibcGBUFp/s87ksSDjLiZInEVzq7NQy4UZTeVHSV04tLJV/iT1Nh9CYSGO+qmcl0EiJggfZaAeSg2DteLgMUby07Fnh2R734jHguMfZJWkt0hUgo3jnLPUSl+qUnKEVI=
Authentication-Results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3077.namprd10.prod.outlook.com (2603:10b6:a03:8c::12)
 by SJ0PR10MB4512.namprd10.prod.outlook.com (2603:10b6:a03:2dc::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19; Tue, 9 Feb
 2021 10:02:53 +0000
Received: from BYAPR10MB3077.namprd10.prod.outlook.com
 ([fe80::74a8:8649:e20b:d571]) by BYAPR10MB3077.namprd10.prod.outlook.com
 ([fe80::74a8:8649:e20b:d571%7]) with mapi id 15.20.3825.030; Tue, 9 Feb 2021
 10:02:53 +0000
Subject: Re: [PATCH 1/2] KVM: x86/xen: Allow reset of Xen attributes
To:     David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>, graf@amazon.com,
        iaslan@amazon.de, pdurrant@amazon.com, aagch@amazon.com,
        fandree@amazon.com, hch@infradead.org
References: <20210208232326.1830370-1-dwmw2@infradead.org>
From:   Joao Martins <joao.m.martins@oracle.com>
Message-ID: <7bbe335f-b767-29cb-cb90-0324f5814126@oracle.com>
Date:   Tue, 9 Feb 2021 10:02:45 +0000
In-Reply-To: <20210208232326.1830370-1-dwmw2@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [94.61.1.144]
X-ClientProxiedBy: LO2P265CA0310.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a5::34) To BYAPR10MB3077.namprd10.prod.outlook.com
 (2603:10b6:a03:8c::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.67] (94.61.1.144) by LO2P265CA0310.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:a5::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19 via Frontend Transport; Tue, 9 Feb 2021 10:02:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 91d2db04-3256-4def-0176-08d8cce1ddd5
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4512:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SJ0PR10MB45123771198C04D0440D334BBB8E9@SJ0PR10MB4512.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dD6iJ9b0UZLczdIAv6EHl1RmKaT/tT1yHmCMjWJYk3YRcELiKq7zOOgsJnkq0DVNBWW0uZrTTPNq4G1vEg66BlxgC1khOCvt3baL/0VSVADKrEpxWGqOUua+itm7Sgc0NiPTnWdbtCCuEjFqsF5ejzyk22DcHIcJQ4e+S9hc6uot9Pb25LwnzyYfwrAaNNFYWjVGdgtDxcWTIkW3FWtwV36TwaHjJu9sDwymERQP9tRdlHDaNSVt1gM4uPBBoYil5bggFJGlTRxh6ti0G0viOMrwAl1ylYTi984NkW9e0rR8vvUglMgNyrYbJ6cPKi6w8uJ9l+0shURSvnY7WZ5VvvzUCgnoWhIhHSuLGys5UvfNQwdwhG03u7eWUiLww23t1Y74ZcZh6PHJvDA8GcIO4Yq0jw29ugdPPHm9OooRcPNzbp4fdLiNHzZJHe6dwhcqvjenxcPfOKvW6JiVskz18vrDvzggYpt0mV+PObbGocO9cD+WCF7RJKuTHpbWT9H2MZ1j5RsuLQ4tKv39N5fkEnJWgDbszyxACFqkEOxiNQkv7JqkoBNsU+q9QRWCHs3CuAJS3eutXJPKzbqrjzZL0A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3077.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(366004)(376002)(136003)(39860400002)(8936002)(6486002)(2616005)(66946007)(86362001)(66476007)(956004)(66556008)(7416002)(26005)(4326008)(53546011)(31686004)(186003)(16526019)(478600001)(83380400001)(16576012)(54906003)(5660300002)(6666004)(316002)(2906002)(8676002)(36756003)(31696002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?SHp6emFQZUYybDdPWVF3QlU5M1d1TU5OSmcvb1IzK0R0MmZkcTNoU2pvSXQr?=
 =?utf-8?B?M0NaR3Y0K0pMQUlTQXVxRU9nbXUyVGpicVM2dzRBWDBBelVNcTBRUUl3ZjRu?=
 =?utf-8?B?cDloRnNNM0pmd2RDVG45ZHFTRmpjMGdvOVk3cXpJdGxNVDZGcGc2ZmVEQ0Z6?=
 =?utf-8?B?L0RJL01wSC9rRGs2QWp2UEhiTDQwSDFIcGdJY1hJdUpBa3hjbW9IZnRYUWVM?=
 =?utf-8?B?Q3Z6Y2hjNE95UVBCM3ArYkhSekRXSjI5eTBsc09xeU9WODNObGtyZE5VK256?=
 =?utf-8?B?SmVsZE54VCtuV21vc1JkajBMMDNta0d3dGg1VVhJM0ZoSVVhMjBtbGo4UGd1?=
 =?utf-8?B?WU9VS2txcytwb2xHcGNrdjdPbmF5WjVEdG41YXBWNEdkR1U1SHhSTjRDQnZ2?=
 =?utf-8?B?cVUzQTJOZmhUUlAxaUgrUk1JOXdNVUpqUWVuNnlKWnRReUwrVXlleXA2Sy8x?=
 =?utf-8?B?VThJRUpSU0Uyd1FZOGR2TzlqVUVTV0FiaFZHQnVTRGw1b2w2eFpGRTAxbitz?=
 =?utf-8?B?WU5nTHVzT2tFdXc4MWdKK0FvU1dTOVdXdnk2THYweDcxb29HMFAvWk1SSVNU?=
 =?utf-8?B?azJDcVBwdmdCblp1WHdidkpPZFdudFRNQ1ZBVjd2aUFkb3czUWhUeURuSmEx?=
 =?utf-8?B?bzIrWmtHM0QvSFNRRW96eW5VdUFCOXFpNVRnN1k4YWcvRTFpS3M5enJQZkcv?=
 =?utf-8?B?WGk2TisrSGkyV2UxQUZPSVlpYU5NZUxyT21PZlZ1SlFoU0ExbVQzR0E0MXNj?=
 =?utf-8?B?eGxJait0cUxwQjNZcW5VdmNMUkdXMXRtUWNvUDhObzBpazRSUlNUWVdkUktz?=
 =?utf-8?B?cEdkZjFIeGU1UjhpMDBkTXQyVTdUNmpUK1I4THJTbXZlby9wcDdyUis2Q1dC?=
 =?utf-8?B?Qk1KYXNIMHRXTUp0UzdHS1Y4NmFUNUFtbE1YOWxGNEpCaTNHc0pjdERjUHhs?=
 =?utf-8?B?SXdCYS9lUW9PK0JvS1RtOXJpQUV0dDQxdmJlcmJ4Z1ZyUDJkZU4wdnplSXQ2?=
 =?utf-8?B?eStRZmsxNmtOQTVJdlVtaGc3YUNRYy8zRVYzV1M3YXhqT0VvOHgvUnlJNE8z?=
 =?utf-8?B?dmdFeEYyRldYeTZNTmtCbVNPYTRIUWQ2Q0paMk5IVmxCTEVKc2FQZnV5bldj?=
 =?utf-8?B?TDlySUlZODViclNFSEdJOE5ySkNqYTd1OUlPKzN6eitiZzBob05XdTJOa3hx?=
 =?utf-8?B?V1BSRmN3TnlUTmtFbnpQMllIeit1Um9KYXZ2Nk95WE5YUDNWTGNDNDFpMitm?=
 =?utf-8?B?STlJTUpUbHRqSGJQTnhpSTFUREYwY1RnaHgwWklpK2FoMS8rWDVlb2tTSzNr?=
 =?utf-8?B?ZzhmKzRyVDNVb1lST3M4eGhBTWVBK25mTWhRNTZja2NPNjc3TEpXQmRvL0Ni?=
 =?utf-8?B?L2lFWkdkS2h6U3NSaWNZRUJpMStFaXZuajFvNnJzRDE0eWVNVXFNTnprVG5D?=
 =?utf-8?B?VHl0VmlBeEZYZGRXQkRrdks3aENXUkMvVEVLdlRpdmNONDdHM0N3djRlanNQ?=
 =?utf-8?B?Y1pHUlJFOEhjckxtc3BDblY2ZTFNdTJCMGgzTXpuMW82STJ2aEpXQVdpalBH?=
 =?utf-8?B?OHA3REZsSEtiYWpVSFBpajRQN25CclpTazdnY1Q0U3I1ajM4R2dsRjl2QXRG?=
 =?utf-8?B?bHJaL241TXJyeUw2dTBlL09xS2lYWmNIQjZhUElmdmRvdVRwTmREaFJlYTdT?=
 =?utf-8?B?S0VBbk9TVmtmNjNhbjJnclZ1R3lDN3NMVUJmcXZnblZ4Qnk1dW5LSVVkR0Jo?=
 =?utf-8?Q?QmBKsbujVm2jwXoenGNTt9EwdF+6BnbYWW1t2GD?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91d2db04-3256-4def-0176-08d8cce1ddd5
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3077.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2021 10:02:53.6676
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MGEGQjpxlPCP2wSupLQ7ohto3lsZ4Y8cRpvwjZp3euYdXcvkAp9B8RdWqx1oWJ5lAZ4/JUWcmxbzGFSbg9hSC5Tlx2RRSufCBNjFL7XXxbQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4512
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9889 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 mlxscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102090048
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9889 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 impostorscore=0
 priorityscore=1501 bulkscore=0 suspectscore=0 mlxscore=0 phishscore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1011 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102090048
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/8/21 11:23 PM, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> In order to support Xen SHUTDOWN_soft_reset (for guest kexec, etc.) the
> VMM needs to be able to tear everything down and return the Xen features
> to a clean slate.
> 
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>

Reviewed-by: Joao Martins <joao.m.martins@oracle.com>

> ---
>  arch/x86/kvm/xen.c | 38 ++++++++++++++++++++++++++++----------
>  1 file changed, 28 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
> index 39a7ffcdcf22..06fec10ffc4f 100644
> --- a/arch/x86/kvm/xen.c
> +++ b/arch/x86/kvm/xen.c
> @@ -118,12 +118,17 @@ int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
>  		break;
>  
>  	case KVM_XEN_ATTR_TYPE_SHARED_INFO:
> +		if (data->u.shared_info.gfn == GPA_INVALID) {
> +			kvm->arch.xen.shinfo_set = false;
> +			r = 0;
> +			break;
> +		}
>  		r = kvm_xen_shared_info_init(kvm, data->u.shared_info.gfn);
>  		break;
>  
>  
>  	case KVM_XEN_ATTR_TYPE_UPCALL_VECTOR:
> -		if (data->u.vector < 0x10)
> +		if (data->u.vector && data->u.vector < 0x10)
>  			r = -EINVAL;
>  		else {
>  			kvm->arch.xen.upcall_vector = data->u.vector;
> @@ -152,10 +157,11 @@ int kvm_xen_hvm_get_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
>  		break;
>  
>  	case KVM_XEN_ATTR_TYPE_SHARED_INFO:
> -		if (kvm->arch.xen.shinfo_set) {
> +		if (kvm->arch.xen.shinfo_set)
>  			data->u.shared_info.gfn = gpa_to_gfn(kvm->arch.xen.shinfo_cache.gpa);
> -			r = 0;
> -		}
> +		else
> +			data->u.shared_info.gfn = GPA_INVALID;
> +		r = 0;
>  		break;
>  
>  	case KVM_XEN_ATTR_TYPE_UPCALL_VECTOR:
> @@ -184,6 +190,11 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
>  		BUILD_BUG_ON(sizeof(struct vcpu_info) !=
>  			     sizeof(struct compat_vcpu_info));
>  
> +		if (data->u.gpa == GPA_INVALID) {
> +			vcpu->arch.xen.vcpu_info_set = false;
> +			break;
> +		}
> +
>  		r = kvm_gfn_to_hva_cache_init(vcpu->kvm,
>  					      &vcpu->arch.xen.vcpu_info_cache,
>  					      data->u.gpa,
> @@ -195,6 +206,11 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
>  		break;
>  
>  	case KVM_XEN_VCPU_ATTR_TYPE_VCPU_TIME_INFO:
> +		if (data->u.gpa == GPA_INVALID) {
> +			vcpu->arch.xen.vcpu_time_info_set = false;
> +			break;
> +		}
> +
>  		r = kvm_gfn_to_hva_cache_init(vcpu->kvm,
>  					      &vcpu->arch.xen.vcpu_time_info_cache,
>  					      data->u.gpa,
> @@ -222,17 +238,19 @@ int kvm_xen_vcpu_get_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
>  
>  	switch (data->type) {
>  	case KVM_XEN_VCPU_ATTR_TYPE_VCPU_INFO:
> -		if (vcpu->arch.xen.vcpu_info_set) {
> +		if (vcpu->arch.xen.vcpu_info_set)
>  			data->u.gpa = vcpu->arch.xen.vcpu_info_cache.gpa;
> -			r = 0;
> -		}
> +		else
> +			data->u.gpa = GPA_INVALID;
> +		r = 0;
>  		break;
>  
>  	case KVM_XEN_VCPU_ATTR_TYPE_VCPU_TIME_INFO:
> -		if (vcpu->arch.xen.vcpu_time_info_set) {
> +		if (vcpu->arch.xen.vcpu_time_info_set)
>  			data->u.gpa = vcpu->arch.xen.vcpu_time_info_cache.gpa;
> -			r = 0;
> -		}
> +		else
> +			data->u.gpa = GPA_INVALID;
> +		r = 0;
>  		break;
>  
>  	default:
> 
