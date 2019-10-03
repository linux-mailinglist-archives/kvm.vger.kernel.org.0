Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAC4DCB09B
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2019 22:57:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728031AbfJCU5w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Oct 2019 16:57:52 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:42716 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727024AbfJCU5w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Oct 2019 16:57:52 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x93KnGHF189598;
        Thu, 3 Oct 2019 20:57:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=91cRFym20Cd2kTHtY5tbeoGVgKr3+SZl2qG+o/AG188=;
 b=kyzbDYm7+apkHgbAweWr/yckmpPTdsHlNrInNUoI0TdmNDR0JIzAUfU6c63U1n0q7Y6I
 Kwoau9vcrJ6+JLbxxWwEEIS1cSkEeqhsEQ4bN27vlR5N3IurU+nqw1/7ohUXZgjnGMBE
 iHWahbjIEQWI82ma+oiRknnvrrlqzG5n8RtPjUgg6sAdvqOx1SZswLJMJaDxtrfWCz8j
 94u6OzIw5qiF9WMCoH+hWhxwJ6GmDZIRgx8J9CYPLmbcOK6K31vshHn12tJG3sCUbApP
 SVDSlMWTtqaDRdIRPOwqaPKl0hvp86GReAJ9Jc1wKfdHh0svZJHG/iOHcOgHKhKD8a1f VA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2v9yfqq502-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Oct 2019 20:57:46 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x93Kmcgg169860;
        Thu, 3 Oct 2019 20:57:45 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2vdk0sv86n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Oct 2019 20:57:45 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x93Kviog010899;
        Thu, 3 Oct 2019 20:57:44 GMT
Received: from Konrads-MacBook-Pro.local (/10.11.64.190)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 03 Oct 2019 13:57:44 -0700
Subject: Re: [PATCH kvm-unit-tests] vmexit: measure IPI and EOI cost
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
References: <1570116271-8038-1-git-send-email-pbonzini@redhat.com>
From:   Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Organization: Oracle Corporation
Message-ID: <73323608-bc33-5819-083d-7912dc7ee8b9@oracle.com>
Date:   Thu, 3 Oct 2019 13:57:42 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <1570116271-8038-1-git-send-email-pbonzini@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9399 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910030169
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9399 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910030169
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/3/19 8:24 AM, Paolo Bonzini wrote:
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

