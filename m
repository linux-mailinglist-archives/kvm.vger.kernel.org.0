Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BBC919CAF5
	for <lists+kvm@lfdr.de>; Thu,  2 Apr 2020 22:19:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389231AbgDBUTj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Apr 2020 16:19:39 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:42810 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389148AbgDBUTj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Apr 2020 16:19:39 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 032KHsU3159428;
        Thu, 2 Apr 2020 20:19:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=QOwWliHXk0Yfbc465zLbvaHlzTcnUqcU35+6sm4mZCQ=;
 b=i2Wuv/FPtlrxQ+HwLZCmmbN+6iZXyXrpsH0H3uLL+6sMJNW/TzdRQSzAgUY6nI/EjVDC
 j7KBuQjdKIWHEez6OCl2usPeSiqJsiV6saR9LRhgm24WihJ/6odPu5YtshNi4KeXtBo2
 D1vOjYYSosq4gRr6WFNUNBoq3Y7oa+WKg0hW8sH+rup1EXZ5YnJRNpCYAttOTyDNrc7C
 lHPFyvOAT2SJadkUVPDpEKlkiJa1bpweHC31fAvio2u1Vg01DBKUnDp0Ye1IUi8HcTi2
 byRRyNxrQtHQvai66kNYz4SJ5/RQcHh+5CccM88l6RAwhazdFVbaIajwX3fTD79EDqkN 0w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 303yung9na-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Apr 2020 20:19:17 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 032KIZoQ171963;
        Thu, 2 Apr 2020 20:19:17 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 302g4w3nr0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Apr 2020 20:19:17 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 032KJEdm015764;
        Thu, 2 Apr 2020 20:19:15 GMT
Received: from vbusired-dt (/10.154.166.66)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 02 Apr 2020 13:19:13 -0700
Date:   Thu, 2 Apr 2020 15:19:09 -0500
From:   Venu Busireddy <venu.busireddy@oracle.com>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     Ashish Kalra <Ashish.Kalra@amd.com>, pbonzini@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        rientjes@google.com, srutherford@google.com, luto@kernel.org
Subject: Re: [PATCH v6 01/14] KVM: SVM: Add KVM_SEV SEND_START command
Message-ID: <20200402201909.GA657573@vbusired-dt>
References: <cover.1585548051.git.ashish.kalra@amd.com>
 <3f90333959fd49bed184d45a761cc338424bf614.1585548051.git.ashish.kalra@amd.com>
 <20200402062726.GA647295@vbusired-dt>
 <89a586e4-8074-0d32-f384-a4597975d129@amd.com>
 <20200402163717.GA653926@vbusired-dt>
 <8b1b4874-11a8-1422-5ea1-ed665f41ab5c@amd.com>
 <20200402185706.GA655878@vbusired-dt>
 <6ced22f7-cbe5-a698-e650-7716566d4d8a@amd.com>
 <20200402194313.GA656773@vbusired-dt>
 <f715bf99-0158-4d5f-77f3-b27743db3c59@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f715bf99-0158-4d5f-77f3-b27743db3c59@amd.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9579 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 suspectscore=5
 mlxscore=0 spamscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004020148
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9579 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 lowpriorityscore=0
 malwarescore=0 adultscore=0 priorityscore=1501 mlxlogscore=999 bulkscore=0
 suspectscore=5 mlxscore=0 spamscore=0 impostorscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004020148
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-04-02 15:04:54 -0500, Brijesh Singh wrote:
> 
> On 4/2/20 2:43 PM, Venu Busireddy wrote:
> > On 2020-04-02 14:17:26 -0500, Brijesh Singh wrote:
> >> On 4/2/20 1:57 PM, Venu Busireddy wrote:
> >> [snip]...
> >>
> >>>> The question is, how does a userspace know the session length ? One
> >>>> method is you can precalculate a value based on your firmware version
> >>>> and have userspace pass that, or another approach is set
> >>>> params.session_len = 0 and query it from the FW. The FW spec allow to
> >>>> query the length, please see the spec. In the qemu patches I choose
> >>>> second approach. This is because session blob can change from one FW
> >>>> version to another and I tried to avoid calculating or hardcoding the
> >>>> length for a one version of the FW. You can certainly choose the first
> >>>> method. We want to ensure that kernel interface works on the both cases.
> >>> I like the fact that you have already implemented the functionality to
> >>> facilitate the user space to obtain the session length from the firmware
> >>> (by setting params.session_len to 0). However, I am trying to address
> >>> the case where the user space sets the params.session_len to a size
> >>> smaller than the size needed.
> >>>
> >>> Let me put it differently. Let us say that the session blob needs 128
> >>> bytes, but the user space sets params.session_len to 16. That results
> >>> in us allocating a buffer of 16 bytes, and set data->session_len to 16.
> >>>
> >>> What does the firmware do now?
> >>>
> >>> Does it copy 128 bytes into data->session_address, or, does it copy
> >>> 16 bytes?
> >>>
> >>> If it copies 128 bytes, we most certainly will end up with a kernel crash.
> >>>
> >>> If it copies 16 bytes, then what does it set in data->session_len? 16,
> >>> or 128? If 16, everything is good. If 128, we end up causing memory
> >>> access violation for the user space.
> >> My interpretation of the spec is, if user provided length is smaller
> >> than the FW expected length then FW will reports an error with
> >> data->session_len set to the expected length. In other words, it should
> >> *not* copy anything into the session buffer in the event of failure.
> > That is good, and expected behavior.
> >
> >> If FW is touching memory beyond what is specified in the session_len then
> >> its FW bug and we can't do much from kernel.
> > Agreed. But let us assume that the firmware is not touching memory that
> > it is not supposed to.
> >
> >> Am I missing something ?
> > I believe you are agreeing that if the session blob needs 128 bytes and
> > user space sets params.session_len to 16, the firmware does not copy
> > any data to data->session_address, and sets data->session_len to 128.
> >
> > Now, when we return, won't the user space try to access 128 bytes
> > (params.session_len) of data in params.session_uaddr, and crash? Because,
> > instead of returning an error that buffer is not large enough, we return
> > the call successfully!
> 
> 
> Ah, so the main issue is we should not be going to e_free on error. If
> session_len is less than the expected len then FW will return an error.
> In the case of an error we can skip copying the session_data into
> userspace buffer but we still need to pass the session_len and policy
> back to the userspace.

Sure, that is one way to fix the problem.

> 
> +	ret = sev_issue_cmd(kvm, SEV_CMD_SEND_START, data, &argp->error);
> +
> +	if (ret)
> +		goto e_free;
> +
> 
> If user space gets an error then it can decode it further to get
> additional information (e.g buffer too small).
> 
> >
> > That is why I was suggesting the following, which you seem to have
> > missed.
> >
> >>> Perhaps, this can be dealt a little differently? Why not always call
> >>> sev_issue_cmd(kvm, SEV_CMD_SEND_START, ...) with zeroed out data? Then,
> >>> if the user space has set params.session_len to 0, we return with the
> >>> needed params.session_len. Otherwise, we check if params.session_len is
> >>> large enough, and if not, we return -EINVAL?
> > Doesn't the above approach address all scenarios?
> >
