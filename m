Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 911A22D9AC7
	for <lists+kvm@lfdr.de>; Mon, 14 Dec 2020 16:22:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732252AbgLNPV3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Dec 2020 10:21:29 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:54398 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731617AbgLNPV3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Dec 2020 10:21:29 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BEF9bxt193404;
        Mon, 14 Dec 2020 15:20:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=ZjUV7DhRIInKSKJ1BfqDa0lLe99lcc98wQmFoKmrtKM=;
 b=FGravdG3dH1QyI35v/1SwdorpkYyNwv2KeQdWOmHnJQo3ntR58a6kzMbjkZiOtOaYY+B
 oVSNZA9JIGEhSpsa6P2hma5xX0FOzJ4Fnhnv5LpoaK9vp5sa5Ne2Icrcd++7FEIKSuUL
 Qo9ieoqEuWCUF8qmDjS6dgpzAK072xfwDTCbQWic1K5YRzrOZaJwJA6wzLhf+zHc0ybZ
 wXIvJw3r2dzp0EfYY/6TmXRp+qTWuuTpENCw1xQDGkoV7E1eKpiK2kG2dRw9+GR4jxq9
 r8LnGTJjtWt8I2eFa5WO4MFNRVdLAJh/LS3Tm6hYNMWHsf/K14ByPl6ySx7rV3wlxcMU Jw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 35ckcb5vgm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 14 Dec 2020 15:20:37 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BEFA5hR048253;
        Mon, 14 Dec 2020 15:20:36 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 35d7supk3y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Dec 2020 15:20:36 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0BEFKYQ9013907;
        Mon, 14 Dec 2020 15:20:34 GMT
Received: from [10.175.173.239] (/10.175.173.239)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 14 Dec 2020 07:20:34 -0800
Subject: Re: [PATCH v3 12/17] KVM: x86/xen: setup pvclock updates
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>, graf@amazon.com,
        iaslan@amazon.de, pdurrant@amazon.com, aagch@amazon.com,
        fandree@amazon.com, kvm@vger.kernel.org
References: <20201214083905.2017260-1-dwmw2@infradead.org>
 <20201214083905.2017260-13-dwmw2@infradead.org>
 <5cb7cd9b-cdeb-be12-7e86-040b7610b2e7@oracle.com>
 <7bb3bdebb32c2536e67f658a80c3efa09077cc0f.camel@infradead.org>
From:   Joao Martins <joao.m.martins@oracle.com>
Message-ID: <cd8ad119-12ac-75e1-93fe-39bdf4e16385@oracle.com>
Date:   Mon, 14 Dec 2020 15:20:30 +0000
MIME-Version: 1.0
In-Reply-To: <7bb3bdebb32c2536e67f658a80c3efa09077cc0f.camel@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9834 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012140107
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9834 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 priorityscore=1501 mlxscore=0 suspectscore=0 adultscore=0 phishscore=0
 malwarescore=0 impostorscore=0 lowpriorityscore=0 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012140107
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/14/20 2:58 PM, David Woodhouse wrote:
> On Mon, 2020-12-14 at 13:29 +0000, Joao Martins wrote:
>> We might be missing the case where only shared_info is registered. Something like:
>>
>>         if (vcpu->xen.shinfo_set && !vcpu->xen.vcpu_info_set) {
>>                 offset = offsetof(struct compat_vcpu_info, time);
>>                 offset += offsetof(struct shared_info, vcpu_info);
>>                 offset += (v - kvm_get_vcpu_by_id(0)) * sizeof(struct compat_vcpu_info);
>>                 
>>                 kvm_setup_pvclock_page(v, &vcpu->xen.shinfo_cache, offset);
>>         }
>>
>> Part of the reason I had a kvm_xen_setup_pvclock_page() was to handle this all these
>> combinations i.e. 1) shared_info && !vcpu_info 2) vcpu_info and unilaterially updating
>> secondary time info.
>>
>> But maybe introducing this xen_vcpu_info() helper to accommodate all this.
> 
> There was complexity.
> 
> I don't like complexity.
> 
> I made it go away.
> 
Considering what you said earlier, yes, it would be unnecessary complexity.

	Joao
