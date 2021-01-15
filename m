Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7DBD2F7EEE
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 16:07:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726904AbhAOPGr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 10:06:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725910AbhAOPGq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jan 2021 10:06:46 -0500
Received: from mx0b-00190b01.pphosted.com (mx0b-00190b01.pphosted.com [IPv6:2620:100:9005:57f::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 682B0C061757;
        Fri, 15 Jan 2021 07:06:06 -0800 (PST)
Received: from pps.filterd (m0050102.ppops.net [127.0.0.1])
        by m0050102.ppops.net-00190b01. (8.16.0.43/8.16.0.43) with SMTP id 10FF04VL010363;
        Fri, 15 Jan 2021 15:05:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=jan2016.eng;
 bh=t4D3b08MA2SNQwJ5TsRTS+jCUfe2o2LLA+ePXnlcC20=;
 b=cPB1v7jChjvDbn8E/ayfejlQOFVKbErjzvyEfhuqLK77l4M4pM5M4NyacRASnLmnLekA
 40Nrq1EQ0XgzByXYJCZuPyJMdLwT5nKQjs0HWSGY76Zcq7K03O7Sv3xmAWkUlarAUieR
 7v8/6KU3ZEOPQ/iQJ2fHlloDEHvZQcPbLpfPUxkpyDNyLV3oK3Eum16gLmvsdD9thpGA
 TBl4/DwyY9vKsOfE+u07UL64pCNQQB7kQUoPtnrDj7RCFsyv/6X7MDiOCUNeizV1fwOP
 Far6yelF39ppBP9CwCxPu4eIr3iCQ+kxUaca96f5/WngEHNURNFzR62UXcYmJx+kuLVT +w== 
Received: from prod-mail-ppoint7 (a72-247-45-33.deploy.static.akamaitechnologies.com [72.247.45.33] (may be forged))
        by m0050102.ppops.net-00190b01. with ESMTP id 363a6nxh6g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 Jan 2021 15:05:48 +0000
Received: from pps.filterd (prod-mail-ppoint7.akamai.com [127.0.0.1])
        by prod-mail-ppoint7.akamai.com (8.16.0.43/8.16.0.43) with SMTP id 10FF5DU6020731;
        Fri, 15 Jan 2021 10:05:47 -0500
Received: from prod-mail-relay19.dfw02.corp.akamai.com ([172.27.165.173])
        by prod-mail-ppoint7.akamai.com with ESMTP id 35y8q4jhbm-1;
        Fri, 15 Jan 2021 10:05:47 -0500
Received: from [0.0.0.0] (prod-ssh-gw01.bos01.corp.akamai.com [172.27.119.138])
        by prod-mail-relay19.dfw02.corp.akamai.com (Postfix) with ESMTP id ECDD860544;
        Fri, 15 Jan 2021 15:05:46 +0000 (GMT)
Subject: Re: [PATCH v2 1/3] KVM: X86: append vmx/svm prefix to additional
 kvm_x86_ops functions
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Andrea Arcangeli <aarcange@redhat.com>
References: <cover.1610680941.git.jbaron@akamai.com>
 <ed594696f8e2c2b2bfc747504cee9bbb2a269300.1610680941.git.jbaron@akamai.com>
 <YAFe6b/sSdDvXSM3@hirez.programming.kicks-ass.net>
From:   Jason Baron <jbaron@akamai.com>
Message-ID: <80e5aca8-8855-e039-c679-1399bd49c17e@akamai.com>
Date:   Fri, 15 Jan 2021 10:05:46 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <YAFe6b/sSdDvXSM3@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-15_08:2021-01-15,2021-01-15 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 adultscore=0
 mlxlogscore=720 suspectscore=0 mlxscore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101150095
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-15_08:2021-01-15,2021-01-15 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 priorityscore=1501
 lowpriorityscore=0 suspectscore=0 impostorscore=0 mlxscore=0 clxscore=1015
 malwarescore=0 mlxlogscore=616 phishscore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101150095
X-Agari-Authentication-Results: mx.akamai.com; spf=${SPFResult} (sender IP is 72.247.45.33)
 smtp.mailfrom=jbaron@akamai.com smtp.helo=prod-mail-ppoint7
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/15/21 4:22 AM, Peter Zijlstra wrote:
> 
> On Thu, Jan 14, 2021 at 10:27:54PM -0500, Jason Baron wrote:
> 
>> -static void update_exception_bitmap(struct kvm_vcpu *vcpu)
>> +static void svm_update_exception_bitmap(struct kvm_vcpu *vcpu)
> 
> Just to be a total pendant: s/append/Prepend/ on $Subject
> 

Ha - I actually switched $subject to prepend and then switched it
back because I thought I was being pedantic. But maybe not :)
