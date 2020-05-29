Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BE0F1E8879
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 22:04:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728235AbgE2UEL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 16:04:11 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:44810 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728294AbgE2UEJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 May 2020 16:04:09 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04TJhDHE003837;
        Fri, 29 May 2020 20:04:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=wqMUoa2my+P+DgdiVWDGMOTY3MwbtbIygrsoEGreKig=;
 b=GrI6JnTacbV9JhhSHRCI4oC1lT5tyaAbAFrCAxH4CMYiZFe0f+YD/JiLiuVPvkcbN/Cn
 dyqcZCdVRCxO205tKOFsO4YDgBAPlepftgRu/B+O6N0BL+7FixvdiF0qoiSjkzpbp2dq
 FeqrOfrRDDrLWTrMKgD/ddyZkpBZE7wCi5PeeCUdGamWCFo/uGqCNHuHBj02TXUvHwxH
 z3tBKjKFSn+oD9ZravrHXacUgYDnlUfrhUqUliQWfueze8+l8f5gTOw/shpiYzZKE7gL
 TIlfaVpLtQ7Z3iilJRufN0CrX75hj299cG9Df5fhOL0BRqswHERezhzP3iNkjDMN9C85 Ww== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 316u8rc8fx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 29 May 2020 20:04:05 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04TJdP9o168607;
        Fri, 29 May 2020 20:02:04 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 317dduvnf2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 May 2020 20:02:04 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04TK23qi012263;
        Fri, 29 May 2020 20:02:03 GMT
Received: from localhost.localdomain (/10.159.246.35)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 29 May 2020 13:02:03 -0700
Subject: Re: [PATCH 08/30] KVM: nSVM: move map argument out of
 enter_svm_guest_mode
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <20200529153934.11694-1-pbonzini@redhat.com>
 <20200529153934.11694-9-pbonzini@redhat.com>
 <f7946509-ff69-03e3-ec43-90a04714afe3@oracle.com>
 <5fa0a52e-3b67-b545-d74a-7e4050e64559@redhat.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <992d5d56-adda-5dcc-098c-da84038fc978@oracle.com>
Date:   Fri, 29 May 2020 13:02:02 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <5fa0a52e-3b67-b545-d74a-7e4050e64559@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9636 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 phishscore=0 adultscore=0 suspectscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005290147
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9636 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 priorityscore=1501 spamscore=0 cotscore=-2147483648 suspectscore=0
 phishscore=0 clxscore=1015 mlxlogscore=999 bulkscore=0 adultscore=0
 lowpriorityscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005290147
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/29/20 12:04 PM, Paolo Bonzini wrote:
> On 29/05/20 20:10, Krish Sadhukhan wrote:
>>> Unmapping the nested VMCB in enter_svm_guest_mode is a bit of a wart,
>>> since the map is not used elsewhere in the function.  There are
>>> just two calls, so move it there.
>> The last sentence sounds bit incomplete.
> Good point---more precisely, "calls" should be "callers".  "It" refers
> to "unmapping".
>
>> Also, does it make sense to mention the reason why unmapping is not
>> required before we enter guest mode ?
> Unmapping is a host operation and is not visible by the guest; is this
> what you mean?


Yes, I was thinking if we could mention it in the commit message...


-Krish

>
> Paolo
>
