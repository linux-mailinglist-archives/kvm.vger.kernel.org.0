Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 550E899F16
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2019 20:43:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388888AbfHVSn1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Aug 2019 14:43:27 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:45998 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731043AbfHVSn1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Aug 2019 14:43:27 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7MId72g124437;
        Thu, 22 Aug 2019 18:43:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=Vpx+W7UbbHH5sLaI9b3JSk4ZB4LncSYUvj43Ltqr3cY=;
 b=aY/DH6D/ujKy7PmIKfzBF5a2gbkeeR/YDcp+CT5ZzKAwA1jOCG3lOdy+fn2SHeZoxrx7
 bdZYIiHYm3sHn6z165G4RsMQ6YdaG0quIR2G+7YymoaX5hp7CXgafA2hlrzz4Z2PpElg
 uBr/rpctHpwQgH+98RhiQ/6DqHAXKpXCBGN4srv7uLGqCtGsfD4qL20SiO6fVXs9alFp
 7jRToX5EuKk8oKxvXHJOMu95uTzjwzbl19Z9ep4OiQ/qqmGh8B4VEpRlUOKnrBptQCRp
 u2rlSnRFZhdqKysLrQcfh6pkkGPyqxcO0SrvMCpm+qTvAoRzs/ruJF1I/mKxBZF8wvbu QA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2uea7r7sv9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Aug 2019 18:43:10 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7MIgaN2081389;
        Thu, 22 Aug 2019 18:43:10 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2uh2q6bw4g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Aug 2019 18:43:10 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7MIgoFZ010478;
        Thu, 22 Aug 2019 18:42:50 GMT
Received: from char.us.oracle.com (/10.152.32.25)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 22 Aug 2019 11:42:50 -0700
Received: by char.us.oracle.com (Postfix, from userid 1000)
        id D1B6C6A0141; Thu, 22 Aug 2019 14:44:40 -0400 (EDT)
Date:   Thu, 22 Aug 2019 14:44:40 -0400
From:   Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        jmattson@redhat.com, ehabkost@redhat.com
Subject: Re: [PATCH 2/3] KVM: x86: always expose VIRT_SSBD to guests
Message-ID: <20190822184440.GA9964@char.us.oracle.com>
References: <1566376002-17121-1-git-send-email-pbonzini@redhat.com>
 <1566376002-17121-3-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1566376002-17121-3-git-send-email-pbonzini@redhat.com>
User-Agent: Mutt/1.9.1 (2017-09-22)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9357 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=981
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908220163
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9357 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908220162
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 21, 2019 at 10:26:41AM +0200, Paolo Bonzini wrote:
> Even though it is preferrable to use SPEC_CTRL (represented by
> X86_FEATURE_AMD_SSBD) instead of VIRT_SPEC, VIRT_SPEC is always
> supported anyway because otherwise it would be impossible to
> migrate from old to new CPUs.  Make this apparent in the
> result of KVM_GET_SUPPORTED_CPUID as well.
> 
> While at it, reuse X86_FEATURE_* constants for the SVM leaf too.
> 
> However, we need to hide the bit on Intel processors, so move
> the setting to svm_set_supported_cpuid.
> 
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Thank you!
